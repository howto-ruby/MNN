class CreateFeedSites < ActiveRecord::Migration
  def change
    create_table :feed_sites do |t|
      t.string   :title
      t.string   :url
      t.string   :etag
      t.text     :description
      t.integer  :category_id
      t.integer  :feed_type
      t.integer  :user_id
      t.datetime :last_modified
      t.string   :site_url
      t.string   :image
      t.integer  :sort_order,  default: 100
      t.timestamps
    end
    add_index :feed_sites, :user_id
    add_index :feed_sites, :category_id
  end
end
