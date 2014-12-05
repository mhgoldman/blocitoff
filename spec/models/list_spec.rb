require 'rails_helper'

RSpec.describe List, :type => :model do
	it { should belong_to(:user) }
	it { should validate_presence_of(:user) }
	it { should validate_presence_of(:name) } 
	it { should_not allow_value('').for(:name) }
end
