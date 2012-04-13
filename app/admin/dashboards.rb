ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.  

  ##################
  ### DASHBOARD ####
  ##################


  
  ### COMMENTS
  section "Recent Comments", :priority => 1 do
    table_for Comment.recent(16) do
      column "User" do |t|
        if t.owner
          link_to t.owner.title, admin_user_path(t.owner)
        else
          t.owner_id
        end
      end
      column "Message" do |t|
        link_to t.body.truncate(60), admin_comment_path(t), :title => t.body
      end
      column "Item" do |t|
        if t.commentable && t.commentable_type == "Item"
          link_to t.commentable.title.truncate(50), admin_item_path(t.commentable), :title => t.commentable.title
        elsif t.commentable && t.commentable_type == "Comment"
          link_to t.commentable.commentable.title.truncate(50), admin_item_path(t.commentable.commentable)
          # link_to("Reply to: #{t.commentable.body.truncate(50)}", admin_comment_path(t.commentable))
        end
      end
      column "Time" do |t|
        "#{time_ago_in_words(t.created_at)} ago"
      end
      column "IP" do |t|
        link_to(t.user_ip, "http://www.geoiptool.com/en/?IP=#{t.user_ip}", :target => "_blank")
      end
    end
  end

  section "Pending Comments", :priority => 2 do
    table_for Comment.as_spam(16) do
      column "User" do |t|
        if t.owner
          link_to t.owner.title, admin_user_path(t.owner)
        else
          t.owner_id
        end
      end
      column "Message" do |t|
        link_to t.body.truncate(50), admin_comment_path(t), :title => t.body
      end
      column "Item" do |t|
        if t.commentable && t.commentable_type == "Item"
          link_to t.commentable.title.truncate(50), admin_item_path(t.commentable)
        elsif t.commentable && t.commentable_type == "Comment"
          link_to t.commentable.commentable.title.truncate(50), admin_item_path(t.commentable.commentable)
        end
      end
      column "Time" do |t|
        "#{time_ago_in_words(t.created_at)} ago"
      end
      column "IP" do |t|
        link_to(t.user_ip, "http://www.geoiptool.com/en/?IP=#{t.user_ip}", :target => "_blank")
      end
      column "Spam" do |t|
        t.marked_spam
      end
      column "Action" do |t|
        link_to "Delete", admin_comment_path(t), :method => 'delete', :confirm => "Are you sure you want to delete this comment?", :remote => true
      end
    end
  end


  ### ITEMS
  section "Draft Items", :priority => 6 do
    ul do
      Item.recent_drafts(10).collect do |item|
        li link_to("#{item.category_title} - #{item.title} - #{time_ago_in_words(item.updated_at)} ago", admin_item_path(item))
      end
    end
  end
  ### ITEMS
  section "Recently Updated Items", :priority => 10 do
    ul do
      Item.recent_updated(10).collect do |item|
        li(
          link_to("#{item.category_title} - #{item.title} - #{time_ago_in_words(item.updated_at)} ago",
          admin_item_path(item))
        )
      end
    end
  end

  ### USERS
  section "Pending Users for Approval", :priority => 14 do
    ul do
      User.recent_pending(8).collect do |user|
        li link_to(user.title, admin_user_path(user))
      end
    end
  end
  ### USERS
  section "Newly Registered User", :priority => 16 do
    ul do
      User.recent(8).collect do |user|
        li link_to(user.title, admin_user_path(user))
      end
    end
  end
  ### USERS
  section "Recently Logged in Users", :priority => 20 do
    ul do
      User.logged_in(8).collect do |user|
        li(
          link_to(
            "#{user.title} - #{time_ago_in_words(user.current_sign_in_at)} ago", 
            admin_user_path(user)
          )
        )
      end
    end
  end

  ### HISTORY
  section "Database History", :priority => 24 do
    table_for Version.order('id desc').limit(20) do
      column "Record" do |v| 
        if v.item
          link_to(
            "#{v.item_type.underscore.humanize} ##{v.item_id}",
            url_for(:controller => "admin/#{v.item.class.to_s.underscore.pluralize}", :action => 'show', :id => v.item_id)
          )
        else
          "#{v.item_type.underscore.humanize} ##{v.item_id}"
        end
      end
      column "Action" do |v|
        link_to(v.event,admin_version_path(v))
      end
      column "Reason" do |v|
        v.tag
      end
      column "When" do |v|
        v.created_at.to_s :short
      end
      column "User" do |v|
        user = User.where(:id => v.whodunnit).first
        if user
          (link_to user.title, admin_user_path(v.whodunnit))
        else
          ""
        end
      end
      column "View" do |v|
        link_to('Details',admin_version_path(v))
      end
    end
  end

end
