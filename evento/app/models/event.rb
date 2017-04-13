class Event < ApplicationRecord
  belongs_to :category
  belongs_to :user, :class_name => "User", :foreign_key => 'creator_id'  # Creator

  alias_attribute :attendees, :users
  has_and_belongs_to_many :users  # Attendees

  # Check that objects themselves are present, not only id:s
  validates :category, :user, :time, presence: true  
  
  validate :time_must_be_in_the_future
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }

  # TODO: VALIDATE LOCATION AND DURATION ONCE THEY ARE ADDED/IMPLEMENTED

  def time_must_be_in_the_future
    if !time.present? || DateTime.current > time
      errors.add(:time, "cant be in the past")
    end
  end

end
