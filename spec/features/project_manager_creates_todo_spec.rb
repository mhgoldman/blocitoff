require 'rails_helper'

feature 'Project manager creates TODO' do
	#TODO... should the duplicate code  go into a before block? because that totally doesn't work.
	before do
		u = User.new(email: 'me@mgoldman.com', password: 'somepa$$word1', password_confirmation: 'somepa$$word1')
		u.skip_confirmation!
		u.save
	end

	scenario 'Successfully' do
		visit new_user_session_path
		fill_in 'Email', with: 'me@mgoldman.com'
		fill_in 'Password', with: 'somepa$$word1'
		click_button 'Log in'
		expect(page).to have_content('Signed in successfully')		

		visit new_todo_path
		fill_in 'Description', with: 'Meet up with the team'
		click_button 'Save'
		expect(page).to have_content('Your new TODO was saved')
		expect(page).to have_content('Meet up with the team')
	end

	scenario 'With description missing' do
		visit new_user_session_path
		fill_in 'Email', with: 'me@mgoldman.com'
		fill_in 'Password', with: 'somepa$$word1'
		click_button 'Log in'
		expect(page).to have_content('Signed in successfully')		

		visit new_todo_path
		click_button 'Save'
		expect(page).to have_content("Description can't be blank")
	end

	scenario 'Without being logged in' do
		visit new_todo_path
		expect(page).to have_content("You need to sign in")		
	end
end