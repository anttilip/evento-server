class Category < ApplicationRecord
  has_many :events
  belongs_to :category, optional: true  # Parent

  validates :name, presence: true, length: { minimum: 3, maximum: 15 }

  def get_events
    subcategory_events = []
    get_subcategories.each {|c| subcategory_events += c.events}
    subcategory_events + events
  end

  def get_subcategories
    Category.where(parent_id: id)
  end

end
