require 'rails_helper'

RSpec.describe Api::ListsController, :type => :controller do
before do
		@list = create(:list)
		@user = @list.user

		@other_user = create(:user)
		@other_list = create(:list, user: @other_user)
		@other_list_open = create(:list, permissions: 'open', user: @other_user)
		@other_list_viewable = create(:list, permissions: 'viewable', user: @other_user)
	end

	describe 'GET index' do	
		it "lists own lists and other users' open/viewable lists if logged in" do
			sign_in(@user)

			get :index, format: :json

			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:lists].count).to eq 3

			expect(json[:lists][0][:owner_email]).to eq @user.email
			expect(json[:lists][0][:permissions]).to eq 'private'

			expect(json[:lists][1][:owner_email]).to eq @other_user.email
			expect(json[:lists][1][:permissions]).to eq 'open'

			expect(json[:lists][2][:owner_email]).to eq @other_user.email
			expect(json[:lists][2][:permissions]).to eq 'viewable'
		end

		it "lists open/viewable lists if not logged in" do
			get :index, format: :json
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:lists].count).to eq 2

			expect(json[:lists][0][:owner_email]).to eq @other_user.email
			expect(json[:lists][0][:permissions]).to eq 'open'

			expect(json[:lists][1][:owner_email]).to eq @other_user.email
			expect(json[:lists][1][:permissions]).to eq 'viewable'
		end
	end

	describe 'DELETE list' do
		it "doesn't allow deletion when not signed in" do
      delete :destroy, id: @list.id, format: :json
      expect(response).to have_http_status :forbidden
		end

		it "allows deletion of own list" do
			sign_in(@user)

			expect(@user.lists.count).to eq 1
			delete :destroy, id: @list.id, format: :json
			expect(@user.lists.count).to eq 0
		end

		it "allows deletion of other user's open list" do
			sign_in(@user)

      delete :destroy, id: @other_list_open.id, format: :json
      expect(response).to have_http_status :no_content
		end

		it "doesn't allow deletion of other user's viewable list" do
			sign_in(@user)

      delete :destroy, id: @other_list_viewable.id, format: :json
      expect(response).to have_http_status :forbidden
		end
	end

	describe 'POST list' do
		def test_create_list(user, should_succeed)
			sign_in(user) if user

			expect(@user.lists.count).to eq 1
			post :create, list: { name: 'new list' }, format: :json

			if should_succeed
				expect(response).to have_http_status :created
				expect(@user.lists.count).to eq 2
			else
				expect(["403","404"].include?(response.code))
				expect(@user.lists.count).to eq 1
			end
		end

		it "allows creation of list if logged in" do
			test_create_list(@user, true)
		end

		it "doesn't allow creation of list if not logged in" do
			test_create_list(nil, false)
		end
	end

	describe 'PUT list' do
		def test_update_list(list, user, should_succeed)
			sign_in(user) if user
			old_name = list.name

			put :update, id: list.id, list: { name: 'changed name' }, format: :json

			if should_succeed
				expect(response).to have_http_status :no_content
				expect(list.reload.name).to eq 'changed name'
			else
				expect(["403","404"].include?(response.code))
				expect(list.reload.name).to eq old_name
			end
		end

		it "allows updating of own list" do
			test_update_list(@list, @user, true)
		end

		it "allows updating of someone else's list if permissions are open" do
			test_update_list(@other_list_open, @user, true)
		end

		it "doesn't allow updating of someone else's list if permissions are NOT open" do
			[@other_list, @other_list_viewable].each do |list|
				test_update_list(list, @user, false)
			end
		end

		it "doesn't allow updating of any list if not logged in" do
			List.all.each do |list|
				test_update_list(list, nil, false)
			end
		end
	end
end