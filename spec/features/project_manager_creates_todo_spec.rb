require 'rails_helper'

include Warden::Test::Helpers

feature 'Project manager creates TODO' do
	before do
		Warden.test_mode!
		@list = create(:list)
	end

	after do
		Warden.test_reset! 
	end

	scenario 'Successfully' do
		login_as(@list.user, scope: :user)

		visit list_path(@list)
		fill_in 'todo_description', with: 'Meet up with the team'
		click_button 'Save'
		expect(page).to have_content('Your new TODO was saved')
		expect(page).to have_content('Meet up with the team')
	end

	scenario 'With description missing' do
		login_as(@list.user, scope: :user)

		visit list_path(@list)
		click_button 'Save'
		expect(page).to have_content("can't be blank")
	end

	scenario 'Without being logged in' do
		visit list_path(@list)
		expect(page).to have_content("You need to sign in")		
	end
end