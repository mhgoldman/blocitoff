require 'rails_helper'

feature 'Project manager views TODO' do
	before do
		u = User.new(email: 'me@mgoldman.com', password: 'somepa$$word1', password_confirmation: 'somepa$$word1')
		u.skip_confirmation!
		u.save

		@t = Todo.new(description: 'do a thing')
		@t.save
	end

	scenario 'Successfully' do
		visit new_user_session_path
		fill_in 'Email', with: 'me@mgoldman.com'
		fill_in 'Password', with: 'somepa$$word1'
		click_button 'Log in'
		expect(page).to have_content('Signed in successfully')		

		visit todo_path(@t)
		expect(page).to have_content('do a thing')
	end

	scenario 'Without being logged in' do
		visit todo_path(@t)
		expect(page).to have_content("You need to sign in")		
	end
end