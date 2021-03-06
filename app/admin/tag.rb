ActiveAdmin.register RegionTag do
  before_filter only: :index do
    @per_page = 12
  end
  config.per_page = 12
  menu parent: "More", priority: 51, label: "Region Tags"
  form partial: "form"
  index do
    id_column
    column :title
    column :slug do |tag|
      link_to tag.slug, tag_path(tag)
    end
    column "Items" do |tag|
      tag.items.count
    end
    column "Updated" do |t|
      t.updated_at.to_s(:short)
    end
    column "Created" do |t|
      t.created_at.to_s(:short)
    end
    default_actions
  end
end

ActiveAdmin.register CountryTag do
  before_filter only: :index do
    @per_page = 12
  end
  config.per_page = 50
  menu parent: "More", priority: 52, label: "Country Tags"
  form partial: "form"
  index do
    id_column
    column :title
    column :slug do |tag|
      link_to tag.slug, tag_path(tag)
    end
    column "Items" do |tag|
      tag.items.count
    end
    column :created_at
    column :updated_at
    default_actions
  end
end

ActiveAdmin.register GeneralTag do
  before_filter only: :index do
    @per_page = 12
  end
  config.per_page = 12
  menu parent: "More", priority: 53, label: "General Tags"
  form partial: "form"

  index do
    id_column
    column :title
    column :slug do |tag|
      link_to tag.slug, tag_path(tag)
    end
    column "Items" do |tag|
      tag.items.count
    end
    column :created_at
    column :updated_at
    default_actions
  end
end
