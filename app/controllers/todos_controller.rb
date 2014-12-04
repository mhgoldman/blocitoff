class TodosController < ApplicationController
	before_action :authenticate_user!, :set_list
	respond_to :html, :js
	
	def new
		@todo = Todo.new
	end

	def create
		@todo = @list.todos.new(todo_params)

		if @todo.save
			@todo_for_form = Todo.new
			flash[:notice] = 'Your new TODO was saved'
			respond_with(@todo) do |format|
				format.html { redirect_to list_todos_path(@list) }
			end
		else
			@todo_for_form = @todo
			respond_with(@todo) do |format|
				format.html { 
					@todos = @list.todos
					render 'index' 
				}
			end
		end
	end

	def destroy
		unless params[:completed] == "1"
			redirect_to list_todos_path(@list) and return
		end

		@todo = @list.todos.find(params[:id])
		@todo.destroy
		
		flash[:notice] = 'Your TODO was deleted'
		respond_with(@todo) do |format|
			format.html { redirect_to list_todos_path(@list) }
		end
	end

	def index
		@todo = Todo.new
		@todos = @list.todos
	end
	
	private

	def todo_params
		params.require(:todo).permit(:description, :completed)
	end

	def set_list
		@list = current_user.lists.find(params[:list_id])
	end
end