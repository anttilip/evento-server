class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location, :time, :created_at, :updated_at, :attendee_count, :image

  has_one :category
  has_one :creator

  def creator
    UserSerializer.new(object.user, root: false)
  end

  def attendee_count
    object.attendees.count
  end

  def image
    if object.image_url && object.image_url.start_with?('/')
      return $server_url + object.image_url
    else
      return object.image_url
    end
  end
end
