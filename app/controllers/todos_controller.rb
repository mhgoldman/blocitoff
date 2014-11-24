class TodosController < ApplicationController
	before_action :authenticate_user!
	
	def new
		@todo = Todo.new
	end

	def create
		@todo = current_user.todos.new(todo_params)
		if @todo.save
			redirect_to todos_path, notice: 'Your new TODO was saved'
		else
			render 'new',  error: 'OMG error!'
		end
	end

	def destroy
		@todo = current_user.todos.find(params[:id])
		@todo.destroy
		redirect_to todos_path, notice: 'Your TODO was deleted'
	end

	def index
		@todos = current_user.todos
	end
	
	private

	def todo_params
		params.require(:todo).permit(:description)
	end
end
