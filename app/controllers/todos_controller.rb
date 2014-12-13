class TodosController < ApplicationController
	before_action :authenticate_user!, :set_list
	respond_to :html
  helper_method :xeditable?

	def create
		@todo = @list.todos.new(todo_params)
		authorize @todo

		if @todo.save
			@todo_for_form = Todo.new
			flash[:notice] = 'Your new TODO was saved'
			respond_with(@todo) do |format|
				format.html { redirect_to @list }
			end
		else
			@todo_for_form = @todo
			respond_with(@todo) do |format|
				format.html { render 'lists/show' and return }
			end
		end
	end

	def destroy
		@todo = @list.todos.find(params[:id])
		authorize @todo

		unless params[:completed] == "1"
			redirect_to @list and return
		end

		@todo.destroy
		
		flash[:notice] = 'Your TODO was deleted'
		respond_with(@todo) do |format|
			format.html { redirect_to @list }
		end
	end
	
	def xeditable? object = nil
  	true
	end

	private

	def todo_params
		params.require(:todo).permit(:description, :completed)
	end

	def set_list
		@list = policy_scope(List).find(params[:list_id])
	end
end