class ListsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_list, only: [:edit, :update, :destroy, :show]
	respond_to :html, :js
  helper_method :xeditable?

	def new
		@list = List.new
	end

	def edit
	end

	def show
		@todo = Todo.new
	end

	def update
		if @list.update(list_params)
			flash[:notice] = 'Your list was updated'
			respond_with(@todo) do |format|
				format.html { redirect_to lists_path }
			end
		else
			respond_with(@todo) do |format|
				format.html { render 'edit' }
			end
		end
	end

	def create
		@list = current_user.lists.new(list_params)

		if @list.save
			@list_for_form = List.new
			flash[:notice] = 'Your new list was saved'
			respond_with(@todo) do |format|
				format.html { redirect_to lists_path }
			end
		else
			@list_for_form = @list
			respond_with(@list) do |format|
				format.html { 
					@lists = current_user.lists #needed to render index (html)
					render 'index' 
				}
			end
		end
	end

	def destroy
		@list.destroy
				
		flash[:notice] = 'Your list was deleted'
		respond_with(@list) do |format|
			format.html { redirect_to lists_path }
		end
	end

	def index
		@list = List.new
		@lists = current_user.lists
	end
	
	def xeditable? object = nil
  	true
	end

	private

	def list_params
		params.require(:list).permit(:name, :permissions)
	end	

	def set_list
		@list = current_user.lists.find(params[:id])
	end
end
