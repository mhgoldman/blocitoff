require 'rails_helper'

include Warden::Test::Helpers

feature 'Project manager creates TODO' do
	before do
		Warden.test_mode!
		@user = create(:user)
	end

	after do
		Warden.test_reset! 
	end

	scenario 'Successfully' do
		login_as(@user, scope: :user)

		visit todos_path
		fill_in 'new-todo-description', with: 'Meet up with the team'
		click_button 'Save'
		expect(page).to have_content('Your new TODO was saved')
		expect(page).to have_content('Meet up with the team')
	end

	scenario 'With description missing' do
		login_as(@user, scope: :user)

		visit todos_path
		click_button 'Save'
		expect(page).to have_content("can't be blank")
	end

	scenario 'Without being logged in' do
		visit todos_path
		expect(page).to have_content("You need to sign in")		
	end
end