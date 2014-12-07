require 'rails_helper'

feature 'Project manager completes TODO' do
	before do
		Warden.test_mode!
		@todo = create(:todo)
	end

	after do
		Warden.test_reset! 
	end

	scenario 'Successfully' do
		login_as(@todo.list.user)

		visit list_path(@todo.list)
		check "completed_todo_#{@todo.id}"
		click_button 'complete'
		expect(page).to have_content('Your TODO was deleted')
	end
end