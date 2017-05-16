class AddImageUrlToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :image_url, :string
  end
end
