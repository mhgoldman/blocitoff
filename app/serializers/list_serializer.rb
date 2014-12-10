class ListSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :permissions, :owner_email, :todos
  
  def owner_email
  	object.user.email
  end

  def todos
  	  ActiveModel::ArraySerializer.new(object.todos, each_serializer: TodoSerializer)
  end
end
