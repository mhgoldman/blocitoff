require 'rails_helper'

#TODO missing POST

RSpec.describe Api::TodosController, :type => :controller do
	before do
		@user = create(:user)
		@list = create(:list, user: @user)
		create_list(:todo, 3, list: @list)

		@other_user = create(:user)
		@other_list = create(:list, user: @other_user)
		create_list(:todo, 3, list: @other_list)		

		@other_list_open = create(:list, permissions: 'open', user: @other_user)
		create_list(:todo, 3, list: @other_list_open)

		@other_list_viewable = create(:list, permissions: 'viewable', user: @other_user)
		create_list(:todo, 3, list: @other_list_viewable)
	end

	describe "POST todo" do
		def test_create_todo(list, user, should_succeed)
			sign_in(user) if user

			expect(list.todos.count).to eq 3			
			post :create, list_id: list.id, todo: { description: "a new todo" }, format: :json

			if should_succeed
				expect(response.code).to eq "201"
				expect(list.todos.count).to eq 4
			else
				expect(["403","404"].include?(response.code))
				expect(list.todos.count).to eq 3
			end							
		end

		it "allows creation of todo on own list" do
			test_create_todo(@list, @user, true)
		end

		it "allows creation of todo on other user's open list" do
			test_create_todo(@other_list_open, @user, true)
		end

		it "doesn't allow creation of todo on other user's private or viewable lists" do
			[@other_list, @other_list_viewable].each do |list|
				test_create_todo(list, @user, false)
			end
		end

		it "doesn't allow creation of todos regardless of visibility when not logged in" do
			List.all.each do |list|
				test_create_todo(list, nil, false)
			end
		end

		it "doesn't allow creation of todo with blank description" do
			sign_in(@user)

			expect(@list.todos.count).to eq 3
			post :create, list_id: @list.id, todo: {description: ''}, format: :json
			expect(@list.todos.count).to eq 3
			expect(response.code).to eq "422"
		end
	end

	describe "DELETE todo" do
		def test_delete_todo(list, user, should_succeed)
			sign_in(user) if user

			expect(list.todos.count).to eq 3			
			delete :destroy, list_id: @list.id, id: @list.todos.first.id, format: :json

			if should_succeed
				expect(response.code).to eq "204"
				expect(list.todos.count).to eq 2
			else
				expect(["403","404"].include?(response.code))
				expect(list.todos.count).to eq 3
			end							
		end

		it "allows deletion of own todo" do
			test_delete_todo(@list, @user, true)
		end

		it "doesn't allow deletion of todos regardless of visibility when not logged in" do
			List.all.each do |list|
				test_delete_todo(list, nil, false)
	    end
   	end

		it "doesn't allow deletion of other users' non-open todos" do
			@other_user.lists.where("permissions != 'open'").each do |list|
				test_delete_todo(list, @user, false)
	    end
   	end
	end	
end
