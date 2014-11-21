require 'rails_helper'

feature 'Project manager views TODO' do
	before do
		u1 = User.new(email: 'me@mgoldman.com', password: 'somepa$$word1', password_confirmation: 'somepa$$word1')
		u1.skip_confirmation!
		u1.save

		u2 = User.new(email: 'somebodyelse@mgoldman.com', password: 'somepa$$word1', password_confirmation: 'somepa$$word1')
		u2.skip_confirmation!
		u2.save

		@my_todo = Todo.create(description: 'do a thing', user: u1)
	end

	scenario 'Successfully' do
		visit new_user_session_path
		fill_in 'Email', with: 'me@mgoldman.com'
		fill_in 'Password', with: 'somepa$$word1'
		click_button 'Log in'
		expect(page).to have_content('Signed in successfully')		

		visit todo_path(@my_todo)
		expect(page).to have_content('do a thing')
	end

	scenario 'Without being logged in' do
		visit todo_path(@my_todo)
		expect(page).to have_content("You need to sign in")		
	end

	scenario 'That belongs to someone else' do
		visit new_user_session_path
		fill_in 'Email', with: 'somebodyelse@mgoldman.com'
		fill_in 'Password', with: 'somepa$$word1'
		click_button 'Log in'
		expect(page).to have_content('Signed in successfully')		
		
		expect { visit todo_path(@my_todo) }.to raise_error(ActiveRecord::RecordNotFound)
	end
end