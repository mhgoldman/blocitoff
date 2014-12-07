require 'rails_helper'

include Warden::Test::Helpers

feature 'Project manager edits list' do
	before do
		Warden.test_mode!
		@list = create(:list)
	end

	after do
		Warden.test_reset! 
	end

	scenario 'Successfully' do
		login_as(@list.user, scope: :user)

		visit edit_list_path(@list)
		fill_in 'list_name', with: 'my new list name'
		select 'open', from: 'list_permissions'
		click_button 'Save'
		expect(page).to have_content('Your list was updated')
		expect(page).to have_content('my new list name')
		expect(page).to have_content('open')
	end

	scenario 'With name missing' do
		login_as(@list.user, scope: :user)

		visit edit_list_path(@list)
		fill_in 'list_name', with: ''
		click_button 'Save'
		expect(page).to have_content("can't be blank")
	end

	scenario 'Without being logged in' do
		visit edit_list_path(@list)
		expect(page).to have_content("You need to sign in")		
	end
end