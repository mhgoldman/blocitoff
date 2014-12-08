require 'rails_helper'

include Warden::Test::Helpers

feature 'Project manager creates list' do
	before do
		Warden.test_mode!
		@user = create(:user)
	end

	after do
		Warden.test_reset! 
	end

	[true,false].each do |use_ajax|
		feature "With#{use_ajax ? '' : 'out'} ajax", js: use_ajax do
			scenario 'Successfully' do
				login_as(@user, scope: :user)

				visit lists_path
				fill_in 'list_name', with: 'my todo list'
				click_button 'Save'
				expect(page).to have_content('Your new list was saved')
				expect(page).to have_content('my todo list')
			end

			scenario 'With name missing' do
				login_as(@user, scope: :user)

				visit lists_path
				click_button 'Save'
				expect(page).to have_content("can't be blank")
			end

			scenario 'Without being logged in' do
				visit lists_path
				expect(page).to have_content("You need to sign in")		
			end
		end
	end
end