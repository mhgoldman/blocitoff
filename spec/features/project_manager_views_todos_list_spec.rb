require 'rails_helper'

feature 'Project manager views TODO' do
	before do
		Warden.test_mode!
		@list = create(:list)
		@todos = create_list(:todo, 3, list: @list)
	end

	after do
		Warden.test_reset! 
	end

	scenario 'Successfully' do
		login_as(@list.user, scope: :user)	

		visit list_todos_path(@list)
		@todos.each do |todo|
			expect(page).to have_content(todo.description)
		end
	end

	scenario 'Without being logged in' do
		visit list_todos_path(@list)
		expect(page).to have_content("You need to sign in")		
	end
end