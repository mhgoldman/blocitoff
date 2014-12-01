class TodosController < ApplicationController
	before_action :authenticate_user!, :set_list
	respond_to :html, :js
	
	def new
		@todo = @list.todos.new
	end

	def create
		@todo = @list.todos.new(todo_params)
		@todos = @list.todos #needed to render index (html) or to render the todo list if there were previously zero items (js)

		if @todo.save
			@new_todo = @list.todos.new
			flash[:notice] = 'Your new TODO was saved'
			respond_with(@todo) do |format|
				format.html { redirect_to list_todos_path(@list) }
			end
		else
			respond_with(@todo) do |format|
				format.html { render 'index' }
			end
		end
	end

	def destroy
		unless params[:completed] == "1"
			redirect_to list_todos_path(@list) and return
		end

		@todo = @list.todos.find(params[:id])
		@todo.destroy
		
		@new_todo = @list.todos.new
		flash[:notice] = 'Your TODO was deleted'
		respond_with(@todo) do |format|
			format.html { redirect_to list_todos_path(@list) }
		end
	end

	def index
		@todo = @list.todos.new
		@todos = @list.todos.reload #needed because...?
	end
	
	private

	def todo_params
		params.require(:todo).permit(:description, :completed)
	end

	def set_list
		@list = current_user.lists.find(params[:list_id])
	end
end