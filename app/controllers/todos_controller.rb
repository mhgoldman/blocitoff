class TodosController < ApplicationController
	before_action :authenticate_user!
	respond_to :html, :js
	
	def new
		@todo = Todo.new
	end

	def create
		@todo = current_user.todos.new(todo_params)
		@todos = current_user.todos #needed to render index (html) or to render the todo list if there were previously zero items (js)

		if @todo.save
			@new_todo = current_user.todos.new
			flash[:notice] = 'Your new TODO was saved'
			respond_with(@todo) do |format|
				format.html { redirect_to todos_path }
			end
		else
			respond_with(@todo) do |format|
				format.html { render 'index' }
			end
		end
	end

	def destroy
		unless params[:completed] == "1"
			redirect_to todos_path and return
		end

		@todo = current_user.todos.find(params[:id])
		@todo.destroy
		
		@new_todo = current_user.todos.new
		flash[:notice] = 'Your TODO was deleted'
		respond_with(@todo) do |format|
			format.html { redirect_to todos_path }
		end
	end

	def index
		@todo = Todo.new
		@todos = current_user.todos
	end
	
	private

	def todo_params
		params.require(:todo).permit(:description, :completed)
	end
end