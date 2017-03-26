class User < ApplicationRecord
  has_and_belongs_to_many :events

  validates :name, :email, presence: true
  validates :email, uniqueness: true

end
