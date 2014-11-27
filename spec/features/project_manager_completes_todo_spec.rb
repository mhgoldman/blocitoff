require 'rails_helper'

feature 'Project manager completes TODO' do
	before do
		Warden.test_mode!
		@user = create(:user)
		@todos = create(:todo, user: @user)
	end

	after do
		Warden.test_reset! 
	end

	scenario 'Successfully' do
		login_as(@user)

		visit todos_path
		click_button 'complete'
		expect(page).to have_content('Your TODO was deleted')
	end
end