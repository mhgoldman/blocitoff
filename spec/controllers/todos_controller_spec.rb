require 'rails_helper'

RSpec.describe TodosController, :type => :controller do
	# not testing new because it's trivial.
	# not testing create because we'd just be testing validations that are tested in model.

	before do
		@user = create(:user)
		@todo = create(:todo, user: @user)

		@other_user = create(:user)
		@other_todo = create(:todo, user: @other_user)
	end

	describe 'GET index' do	
		it "lists own todos if logged in" do
			sign_in(@user)

			get :index
	    expect(response).to render_template :index			
			expect(assigns(:todos)).to eq ([@todo])		
		end

		it "redirects if not logged in" do
			get :index
			expect(response).to redirect_to(new_user_session_path)
		end
	end

	describe 'DELETE todo' do
		it "doesn't allow deletion when not signed in" do
      delete :destroy, id: @todo.to_param, completed: 1
      expect(response).to redirect_to(new_user_session_path)
		end

		it "allows deletion of own todo" do
			sign_in(@user)

			expect(@user.todos.count).to eq 1
			delete :destroy, {id: @todo.to_param, completed: 1}
			expect(@user.todos.count).to eq 0
		end

		it "doesn't allow deletion of other user's todo" do
			sign_in(@user)

			expect {
        delete :destroy, id: @other_todo.to_param, completed: 1
      }.to raise_error ActiveRecord::RecordNotFound
		end


		it "doesn't delete without completed == 1" do
			sign_in(@user)

			expect(@user.todos.count).to eq 1
			delete :destroy, {id: @todo.to_param}
			expect(@user.todos.count).to eq 1
		end		
	end
end
