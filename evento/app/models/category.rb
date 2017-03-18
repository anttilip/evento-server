class Category < ApplicationRecord
  has_many :events
  belongs_to :category, optional: true  # Parent

  def get_events
    subcategory_events = []
    get_subcategories.each {|c| subcategory_events += c.events}
    subcategory_events + events
  end

  def get_subcategories
    Category.where(parent_id: id)
  end

end
