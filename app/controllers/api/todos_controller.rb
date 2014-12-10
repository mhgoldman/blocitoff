class Api::TodosController < Api::ApiController
	respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error	
	before_filter :ensure_logged_in	

	def create
		list = List.editable_by(current_user).find(params[:list_id])
		todo = list.todos.new(todo_params)

		if todo.save
			respond_with list, todo
		else
			error :unprocessable_entity, list.errors.full_messages
		end
	end

	def destroy
		list = List.editable_by(current_user).find(params[:list_id])
		todo = list.todos.find(params[:id])

		if todo.destroy
			respond_with todo
		else
			error :unprocessable_entity, list.errors.full_messages
		end
	end

	private

	def todo_params
		params.require(:todo).permit(:description)
	end
end
