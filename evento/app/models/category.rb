class Category < ApplicationRecord
  has_many :events
  belongs_to :category, optional: true  # Parent
end
