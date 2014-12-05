require 'rails_helper'

RSpec.describe TodosController, :type => :controller do
	before do
		@todo = create(:todo)
		@list = @todo.list
		@user = @list.user

		@other_todo = create(:todo)
		@other_list = @other_todo.list
		@other_user = @other_list.user
	end

	describe 'GET index' do	
		it "lists own todos if logged in" do
			sign_in(@user)

			get :index, list_id: @list.id
	    expect(response).to render_template :index			
			expect(assigns(:todos)).to eq ([@todo])		
		end

		it "redirects if not logged in" do
			get :index, list_id: @list.id
			expect(response).to redirect_to(new_user_session_path)
		end
	end

	describe 'DELETE todo' do
		it "doesn't allow deletion when not signed in" do
      delete :destroy, id: @todo.to_param, completed: 1, list_id: @list.id
      expect(response).to redirect_to(new_user_session_path)
		end

		it "allows deletion of own todo" do
			sign_in(@user)

			expect(@list.todos.count).to eq 1
			delete :destroy, id: @todo.to_param, completed: 1, list_id: @list.id
			expect(@list.todos.count).to eq 0
		end

		it "doesn't allow deletion of other user's todo" do
			sign_in(@user)

			expect {
        delete :destroy, id: @other_todo.to_param, completed: 1, list_id: @list.id
      }.to raise_error ActiveRecord::RecordNotFound
		end


		it "doesn't delete without completed == 1" do
			sign_in(@user)

			expect(@list.todos.count).to eq 1
			delete :destroy, id: @todo.to_param, list_id: @list.id
			expect(@list.todos.count).to eq 1
		end		
	end
end
