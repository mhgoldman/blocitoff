require 'rails_helper'

feature 'Project manager views TODO' do
	before do
		Warden.test_mode!
		@list = create(:list)
		@todos = create_list(:todo, 3, list: @list)
	end

	after do
		Warden.test_reset! 
	end

	[true,false].each do |use_ajax|
		feature "With#{use_ajax ? '' : 'out'} ajax", js: use_ajax do
			scenario 'Successfully' do
				login_as(@list.user, scope: :user)	

				visit list_path(@list)
				@todos.each do |todo|
					expect(page).to have_content(todo.description)
				end
			end

			scenario 'Without being logged in' do
				visit list_path(@list)
				expect(page).to have_content("You need to sign in")		
			end
		end
	end
end