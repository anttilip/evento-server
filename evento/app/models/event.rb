class Event < ApplicationRecord
  belongs_to :category
  belongs_to :user, :class_name => "User", :foreign_key => 'creator_id'  # Creator
  has_and_belongs_to_many :users  # Attendees
end
