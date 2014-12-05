require 'rails_helper'

RSpec.describe Todo, type: :model do
	it { should belong_to(:list) }
	it { should validate_presence_of(:list) }
	it { should validate_presence_of(:description) } 
	it { should_not allow_value('').for(:description) }

  it "should have correct days_left" do
  	t = create(:todo, created_at: Time.zone.now)

  	expect(t.days_left).to eq 7

  	t.created_at = 6.days.ago
  	t.save
  	expect(t.days_left).to eq 1

  	t.created_at = 7.days.ago
  	t.save
  	expect(t.days_left).to eq 0
	end
end
