require 'rails_helper'

feature 'Project manager views lists' do
	before do
		Warden.test_mode!
		@user = create(:user)
		@lists = create_list(:list, 3, user: @user)
	end

	after do
		Warden.test_reset! 
	end

	scenario 'Successfully' do
		login_as(@user, scope: :user)	

		visit lists_path
		@lists.each do |list|
			expect(page).to have_content(list.name)
		end
	end

	scenario 'Without being logged in' do
		visit lists_path
		expect(page).to have_content("You need to sign in")		
	end
end