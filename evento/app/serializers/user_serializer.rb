class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email # No password hash etc here
end
