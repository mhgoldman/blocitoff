class Api::ListsController < Api::ApiController  
	before_filter :ensure_logged_in, only: [:create, :update, :destroy]
	before_action :set_list, only: [:update, :destroy, :show]

	def index
		lists = policy_scope(List)
		respond_with lists
	end

	def show
		respond_with @list
	end

	def create		
		@list = current_user.lists.new(list_params)
		authorize @list

		if @list.save
			respond_with @list
		else
			error :unprocessable_entity, @list.errors.full_messages
		end
	end

	def update
		if @list.update(list_params)
			respond_with @list
		else
			error :unprocessable_entity, @list.errors.full_messages
		end
	end

	def destroy
		if @list.destroy
			respond_with @list
		else
			error :unprocessable_entity, @list.errors.full_messages
		end
	end		

	private

	def set_list
		@list = policy_scope(List).find(params[:id])
		authorize @list
	end

	def list_params
		params.require(:list).permit(:name, :permissions)
	end	
end