class ListsController < ApplicationController
	before_action :authenticate_user!
	respond_to :html, :js
	
	def new
		@list = List.new
	end

	def create
		@list = current_user.lists.new(list_params)
		@lists = current_user.lists #needed to render index (html) or to render the todo list if there were previously zero items (js)

		if @list.save
			@new_list = current_user.lists.new
			flash[:notice] = 'Your new list was saved'
			respond_with(@todo) do |format|
				format.html { redirect_to lists_path }
			end
		else
			respond_with(@list) do |format|
				format.html { render 'index' }
			end
		end
	end

	def destroy
		@list = current_user.lists.find(params[:id])
		@list.destroy
		
		@lists = current_user.lists
		
		@new_list = current_user.lists.new
		flash[:notice] = 'Your list was deleted'
		respond_with(@list) do |format|
			format.html { redirect_to lists_path }
		end
	end

	def index
		@list = List.new
		@lists = current_user.lists
	end
	
	private

	def list_params
		params.require(:list).permit(:name, :permissions)
	end	
end
