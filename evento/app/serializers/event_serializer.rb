class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location, :time, :created_at, :updated_at, :attendee_count, :image_url

  has_one :category
  has_one :creator

  def creator
    UserSerializer.new(object.user, root: false)
  end

  def attendee_count
    object.attendees.count
  end
end
