class Api::ListsController < Api::ApiController  
	before_filter :ensure_logged_in, only: [:create, :update, :destroy]

	def index
		lists = List.visible_to(current_user)
		respond_with lists
	end

	def show
		list = List.visible_to(current_user).find(params[:id])
		respond_with list
	end

	def create		
		list = current_user.lists.new(list_params)

		if list.save
			respond_with list
		else
			error :unprocessable_entity, list.errors.full_messages
		end
	end

	def update
		list = List.editable_by(current_user).find(params[:id])

		if list.update(list_params)
			respond_with list
		else
			error :unprocessable_entity, list.errors.full_messages
		end
	end

	def destroy
		list = List.editable_by(current_user).find(params[:id])

		if list.destroy
			respond_with list
		else
			error :unprocessable_entity, list.errors.full_messages
		end
	end		

	private

	def list_params
		params.require(:list).permit(:name, :permissions)
	end	
end