class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location, :time, :created_at, :updated_at

  has_one :category
  has_one :creator

  def creator
    UserSerializer.new(object.user, root: false)
  end
end
