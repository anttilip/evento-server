require 'uri'

class Event < ApplicationRecord
  belongs_to :category
  belongs_to :user, :class_name => "User", :foreign_key => 'creator_id'  # Creator

  alias_attribute :attendees, :users
  has_and_belongs_to_many :users  # Attendees

  # Check that objects themselves are present, not only id:s
  validates :category, :user, :time, presence: true

  validate :time_must_be_in_the_future
  validate :must_be_valid_image_url

  validates :title, presence: true, length: { minimum: 3, maximum: 50 }

  # TODO: VALIDATE LOCATION AND DURATION ONCE THEY ARE ADDED/IMPLEMENTED

  def time_must_be_in_the_future
    if !time.present? || DateTime.current > time
      errors.add(:time, "cant be in the past")
    end
  end

  def must_be_valid_image_url
    if !image_url.present? || image_url.start_with?('/')
      # if image doesn't exist or is default one (= starts with '/'),
      # then set/update the image_url to the default one.
      # overrides the url's starting with '/' because otherwise
      # the validation would fail :/
      self.image_url = category ? category.get_default_image : nil;
    elsif !image_url.end_with?('.jpg', '.png', '.gif')
      errors.add(:image_url, "must end with .jpg, .png or .gif")
    else
      uri = URI.parse(image_url)
      if !uri.is_a?(URI::HTTP) || uri.host.nil?
        errors.add(:image_url, "is not valid")
      end
    end
  rescue URI::InvalidURIError
    errors.add(:image_url, "is not valid")
  end
end
