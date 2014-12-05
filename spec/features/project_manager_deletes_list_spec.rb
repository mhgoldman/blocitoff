require 'rails_helper'

feature 'Project manager deletes list' do
	before do
		Warden.test_mode!
		@list = create(:list)
	end

	after do
		Warden.test_reset! 
	end

	scenario 'Successfully' do
		login_as(@list.user)

		visit lists_path
		click_button "destroy_list_#{@list.id}"
		expect(page).to have_content('Your list was deleted')
	end
end