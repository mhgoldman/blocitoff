require 'rails_helper'

feature 'Project manager views TODO' do
	before do
		Warden.test_mode!
		@user = create(:user)
		@todos = create_list(:todo, 3, user: @user)
	end

	after do
		Warden.test_reset! 
	end

	scenario 'Successfully' do
		login_as(@user, scope: :user)	

		visit todos_path
		@todos.each do |todo|
			expect(page).to have_content(todo.description)
		end
	end

	scenario 'Without being logged in' do
		visit todos_path
		expect(page).to have_content("You need to sign in")		
	end
end