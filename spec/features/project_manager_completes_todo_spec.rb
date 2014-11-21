require 'rails_helper'

feature 'Project manager completes TODO' do
	before do
		u = User.new(email: 'me@mgoldman.com', password: 'somepa$$word1', password_confirmation: 'somepa$$word1')
		u.skip_confirmation!
		u.save

		Todo.delete_all
		Todo.create(description: 'do a thing', user: u)
	end

	scenario 'Successfully' do
		visit new_user_session_path
		fill_in 'Email', with: 'me@mgoldman.com'
		fill_in 'Password', with: 'somepa$$word1'
		click_button 'Log in'
		expect(page).to have_content('Signed in successfully')		

		visit todos_path
		click_link 'complete'
		expect(page).to have_content('Your TODO was deleted')
	end
end