require 'rails_helper'

RSpec.describe Todo, type: :model do
	it { should belong_to(:user) }
	it { should validate_presence_of(:user) }
	it { should validate_presence_of(:description) } 
	it { should_not allow_value('').for(:description) }

  it "should have correct days_left" do
  	u = User.new(email: "some@email.com")
  	u.skip_confirmation!
  	u.save

  	t = Todo.create(description: "a thing to do", user: u)
  	expect(t.days_left).to be 7

  	t.created_at = 6.days.ago
  	t.save
  	expect(t.days_left).to be 1

  	t.created_at = 7.days.ago
  	t.save
  	expect(t.days_left).to be 0
	end
end
