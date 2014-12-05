require 'rails_helper'

RSpec.describe ListsController, :type => :controller do
	before do
		@list = create(:list)
		@user = @list.user

		@other_list = create(:list)
		@other_user = @other_list.user
	end

	describe 'GET index' do	
		it "lists own lists if logged in" do
			sign_in(@user)

			get :index
	    expect(response).to render_template :index			
			expect(assigns(:lists)).to eq ([@list])		
		end

		it "redirects if not logged in" do
			get :index
			expect(response).to redirect_to(new_user_session_path)
		end
	end

	describe 'DELETE list' do
		it "doesn't allow deletion when not signed in" do
      delete :destroy, id: @list.id
      expect(response).to redirect_to(new_user_session_path)
		end

		it "allows deletion of own list" do
			sign_in(@user)

			expect(@user.lists.count).to eq 1
			delete :destroy, id: @list.id
			expect(@user.lists.count).to eq 0
		end

		it "doesn't allow deletion of other user's list" do
			sign_in(@user)

			expect {
        delete :destroy, id: @other_list.id
      }.to raise_error ActiveRecord::RecordNotFound
		end
	end	
end
