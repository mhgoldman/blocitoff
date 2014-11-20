require 'rails_helper'

RSpec.describe Todo, type: :model do
	it "should require a description" do
		expect(Todo.new(description: '')).to_not be_valid
	end
end
