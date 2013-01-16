# Comments
ActiveAdmin.register EmailDelivery do
  config.clear_sidebar_sections!
  controller.authorize_resource
  config.comments = false
  menu parent: "Items", priority: 14, label: "Email Delivery", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, EmailDelivery)
  }
  actions  :index, :destroy
  index do
    column :id
    column :item do |t|
      if t.item
        link_to t.item.title, admin_item_path(t.item)
      end
    end
    bool_column :delivered
    column :created_at do |t|
      t.created_at.to_s(:short)
    end
    column "Schedule Time" do |t|
      t.send_at.to_s(:short)
    end
    default_actions
  end
  controller do
    def scoped_collection
       EmailDelivery.includes(:item)
    end
  end
end