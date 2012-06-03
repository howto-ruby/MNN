class ItemsController < ApplicationController
  
  def feed
    headers['Cache-Control'] = 'public, max-age=3600' # 60 minutes cache
  end
  
  # GET /items
  # GET /items.json
  def index
    @show_breadcrumb = true
    if params[:language_id]
      @language = Language.find(params[:language_id])
      @rss_title = "World Mathaba - Latest in #{@language.description}"
      @rss_description = "World Mathaba - Latest News in #{@language.description}"
      @rss_language = @language.locale
      @rss_source = items_path(language_id: params[:language_id], only_path: false, protocol: 'https')
      @items = Item.published.
        not_draft.
        includes(:language, :attachments, :tags, :item_stat, :user).
        where(language_id: @language.id).
        order("published_at DESC").
        page(params[:page]).per(per_page)
    else
      @rss_title = "World Mathaba - Latest News"
      @rss_description = "World Mathaba - Latest News"
      @rss_source = items_path(only_path: false, protocol: 'https')
      @rss_language = "en"
      @items = Item.published.
        not_draft.
        includes(:language, :attachments, :tags, :item_stat, :user).
        order("published_at DESC").
        page(params[:page]).per(per_page)
    end
    if @items.empty?
      @last_published = Time.now
    else
      @last_published = @items.first.published_at
    end
    
    respond_to do |format|
      format.html {
        headers['Cache-Control'] = 'private, max-age=600, must-revalidate' unless (current_admin_user or current_user)
        headers['Last-Modified'] = @last_published.httpdate
      }
      format.json {
        headers['Cache-Control'] = 'public, max-age=600' unless (current_admin_user or current_user) # 10 min
        headers['Last-Modified'] = @last_published.httpdate
        render json: @items 
      }
      format.atom {
        headers['Cache-Control'] = 'public, max-age=3600' unless (current_admin_user or current_user) # 1 hour
        headers['Last-Modified'] = @last_published.httpdate
        render partial: "/shared/items", layout: false }
      format.rss {
        headers['Cache-Control'] = 'public, max-age=3600' unless (current_admin_user or current_user) # 1 hour
        headers['Last-Modified'] = @last_published.httpdate
        render partial: "/shared/items", layout: false 
      }
      format.xml {
        headers['Cache-Control'] = 'public, max-age=600' unless (current_admin_user or current_user) # 10 min
        headers['Last-Modified'] = @last_published.httpdate
        render @items
      }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.includes([:attachments, :comments, :user]).find(params[:id])
    @show_breadcrumb = true
    if @item && is_human? && (@item_stat = @item.item_stat)
      if session[:view_items] && !session[:view_items].include?(@item.id)
        @item_stat.update_attributes(views_counter: @item_stat.views_counter+1)
        session[:view_items] << @item.id
      end
    end
    @meta_title = @item.title + " - World Mathaba"
    @meta_description = @item.abstract
    @meta_keywords = "#{@item.category_title} news, #{@item.tag_list}"
    @meta_author = @item.user.title if @item.user

    # @related = @item.solr_similar
    headers['Cache-Control'] = 'private, no-cache'
    respond_to do |format|
      format.html
      format.json { render json: @item }
    end
  end

  def edit
    redirect_to root_path
  end

  def search
    @show_breadcrumb = false
    if params[:category_id]
      category = Category.where(id: params[:category_id]).first
    end
    if params[:language_id]
      language = Language.where(id: params[:language_id]).first
    end
    if params[:q] && !params[:q].to_s.empty?
      term = params[:q].downcase
      @search = Item.solr_search(include: [:attachments, :comments, :category, :language, :item_stat, :user, :tags]) do
        fulltext term do
          phrase_fields title: 1.8
          phrase_fields abstract: 1.6
          phrase_fields tags: 1.5
          phrase_fields body: 1.4
          phrase_slop   1
        end
        if category
          with(:category_id, category.id)
        end
        if language
          with(:language_id, language.id)
        end
        with(:draft, false)
        facet(:category_id)
        facet(:language_id)
        facet(:user_id)
        order_by(:published_at,:desc)
        paginate page: params[:page], per_page: per_page
      end

      # showing Sponsored Listings
      @items = @search.results
      @title = "WorldMathaba - Found #{@search.total} results for '#{params[:q]}' "
      @meta_title = @title
      @meta_description = @title
      @rss_description = @title
      @rss_title = "WorldMathaba Search - #{params[:q]}"
      @last_published = @items.first.published_at unless @items.empty?
    else
      @items = []
      @title = "Please type something to search for"
    end
    # client side cache for 15 minutes
    headers['Cache-Control'] = 'public, max-age=900' unless (current_admin_user or current_user)
    respond_to do |format|
      format.html
      format.js
      format.atom {
        headers['Cache-Control'] = 'public, max-age=3600' unless (current_admin_user or current_user)
        headers['Last-Modified'] = @last_published.httpdate
        render partial: "/shared/items", layout: false }
      format.rss {
        headers['Cache-Control'] = 'public, max-age=3600' unless (current_admin_user or current_user)
        headers['Last-Modified'] = @last_published.httpdate
        render partial: "/shared/items", layout: false 
      }
    end
  end
  
  comment_destroy_conditions do |comment|
    current_admin_user && (can? :destroy, Comment)
  end
end
