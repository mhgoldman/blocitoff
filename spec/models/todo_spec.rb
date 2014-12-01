require 'rails_helper'

RSpec.describe Todo, type: :model do
	it { should belong_to(:list) }
	it { should validate_presence_of(:list) }
	it { should validate_presence_of(:description) } 
	it { should_not allow_value('').for(:description) }

  it "should have correct days_left" do
  	u = User.new(email: "some@email.com")
  	u.skip_confirmation!
  	u.save

    l = List.create(name: 'my todo list', user: u)

  	t = l.todos.create(description: "a thing to do")
  	expect(t.days_left).to be 7

  	t.created_at = 6.days.ago
  	t.save
  	expect(t.days_left).to be 1

  	t.created_at = 7.days.ago
  	t.save
  	expect(t.days_left).to be 0
	end
end
