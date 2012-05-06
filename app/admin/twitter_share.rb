# Comments
ActiveAdmin.register TwitterShare do
  controller.authorize_resource
  config.comments = false
  menu parent: "Items", priority: 12, label: "Twitter Shares", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, TwitterShare)
  }
  actions  :index
  index do
    id_column
    column :item
    column :status
    column "Job Time", :enqueue_at
    column "Completed At", :processed_at
    column :created_at
  end
  
end