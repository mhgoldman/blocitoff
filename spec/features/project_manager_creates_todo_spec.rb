require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'Project manager creates TODO' do
	before do
		@user = create(:user)
	end

	scenario 'Successfully' do
		login_as(@user, scope: :user)

		visit new_todo_path
		fill_in 'Description', with: 'Meet up with the team'
		click_button 'Save'
		expect(page).to have_content('Your new TODO was saved')
		expect(page).to have_content('Meet up with the team')
	end

	scenario 'With description missing' do
		login_as(@user, scope: :user)

		visit new_todo_path
		click_button 'Save'
		expect(page).to have_content("Description can't be blank")
	end

	scenario 'Without being logged in' do
		visit new_todo_path
		expect(page).to have_content("You need to sign in")		
	end
end