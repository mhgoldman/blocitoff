class Api::TodosController < Api::ApiController
	respond_to :json
	before_action :set_list

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error	
	before_filter :ensure_logged_in	

	def create
		todo = @list.todos.new(todo_params)
		authorize todo

		if todo.save
			respond_with @list, todo
		else
			error :unprocessable_entity, todo.errors.full_messages
		end
	end

	def destroy
		todo = @list.todos.find(params[:id])
		authorize todo
		
		if todo.destroy
			respond_with todo
		else
			error :unprocessable_entity, todo.errors.full_messages
		end
	end

	private

	def set_list
		@list = policy_scope(List).find(params[:list_id])
	end

	def todo_params
		params.require(:todo).permit(:description)
	end
end
