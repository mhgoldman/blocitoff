require 'rails_helper'

feature 'Project manager views TODO' do
	before do
		u = User.new(email: 'me@mgoldman.com', password: 'somepa$$word1', password_confirmation: 'somepa$$word1')
		u.skip_confirmation!
		u.save

		Todo.delete_all
		Todo.create(description: 'do a thing', user: u)
		Todo.create(description: 'do another thing', user: u)
		Todo.create(description: 'do a third thing', user: u)
	end

	scenario 'Successfully' do
		visit new_user_session_path
		fill_in 'Email', with: 'me@mgoldman.com'
		fill_in 'Password', with: 'somepa$$word1'
		click_button 'Log In'
		expect(page).to have_content('Signed in successfully')		

		visit todos_path
		expect(page).to have_content('do a thing')
		expect(page).to have_content('do another thing')
		expect(page).to have_content('do a third thing')

	end

	scenario 'Without being logged in' do
		visit todos_path
		expect(page).to have_content("You need to sign in")		
	end
end