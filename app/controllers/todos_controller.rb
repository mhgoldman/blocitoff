class TodosController < ApplicationController
	before_action :authenticate_user!
	
	def new
		@todo = Todo.new
	end

	def create
		@todo = Todo.new(todo_params)
		if @todo.save
			redirect_to @todo, notice: 'Your new TODO was saved'
		else
			render 'new',  error: 'OMG error!'
		end
	end

	def show
		@todo = Todo.find(params[:id])
	end

	def index
		@todos = Todo.all
	end
	
	private

	def todo_params
		params.require(:todo).permit(:description)
	end
end
