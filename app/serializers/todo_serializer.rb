class TodoSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :description
end
