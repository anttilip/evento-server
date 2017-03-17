class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.integer :category_id
      t.integer :creator_id
      t.string :location
      t.datetime :time

      t.timestamps
    end
  end
end
