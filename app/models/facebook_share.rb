class FacebookShare < Share
  belongs_to :item
  after_create :enqueue

  def post(item)
    self.processed_at = Time.now
    user = User.find Settings.facebook_manager_id
    @user_graph = Koala::Facebook::API.new(user.oauth_token)
    @page_token = @user_graph.get_page_access_token(Settings.facebook_page_id)
    @page_graph = Koala::Facebook::API.new(@page_token)
    url = Rails.application.routes.url_helpers.item_path(item, only_path: false, host: Settings.host)
    if @page_graph
      res = @page_graph.put_wall_post(item.title, {name: item.title, link: url})
    end
    if res && res["id"]
      self.status = res["id"]
      self.save
    else
      res = false
      self.status = 'FAILED'
      self.save
    end
    res
  end
  
  protected
  
  def enqueue
    if Rails.env.production?
      if self.enqueue_at.to_i < Time.now.to_i
        time = Time.now+30
      else
        time = self.enqueue_at
      end
      FacebookQueue.perform_at(time,self.id)
    else
      Rails.logger.info("  Queue: Updating Facebook status: #{self.id}")
    end
  end
  
end
