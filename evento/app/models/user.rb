class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :events

  validates :name, presence: true, length: { minimum: 3, maximum: 40 }

  # we could do some sophisticated email validity check with regex, but lets not
  # https://davidcel.is/posts/stop-validating-email-addresses-with-regex/
  validates_format_of :email, :with => /@/
  validates :email, presence: true, uniqueness: true

  validates :password_digest, presence: true
end
