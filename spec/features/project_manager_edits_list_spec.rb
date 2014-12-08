require 'rails_helper'

include Warden::Test::Helpers

feature 'Project manager edits list' do
	before do
		Warden.test_mode!
		@list = create(:list, name: 'really good list')
	end

	after do
		Warden.test_reset! 
	end

	feature "With AJAX", js: true do
		scenario 'Successfully' do
			login_as(@list.user, scope: :user)

			visit list_path(@list)

			page.find(:xpath,"//*[text()='really good list']").click
			page.find(:css,".input-sm").set 'my new list name'
			page.find(:css,".editable-submit").click
			expect(page).to have_content('Your list was updated')
			expect(page).to have_content('my new list name')

			page.find(:xpath,"//*[text()='private']").click
			page.find(:css,".input-sm").select 'open'
			page.find(:css,".editable-submit").click
			expect(page).to have_content('Your list was updated')
			expect(page).to have_content('open')
		end

		scenario 'With name missing' do
			login_as(@list.user, scope: :user)

			visit list_path(@list)

			page.find(:xpath,"//*[text()='really good list']").click
			page.find(:css,".input-sm").set ''
			page.find(:css,".editable-submit").click
			expect(page).to have_content("can't be blank")
		end

		scenario 'Without being logged in' do
			visit list_path(@list)
			expect(page).to have_content("You need to sign in")		
		end
	end

	feature "Without AJAX" do
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
	
end