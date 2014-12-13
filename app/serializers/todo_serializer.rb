class TodoSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :description, :days_left
end
