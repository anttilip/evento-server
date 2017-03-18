class CreateEventUserJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :events_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true
    end
  end
end
