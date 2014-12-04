require 'rails_helper'

RSpec.describe User, :type => :model do
  it {should have_many(:lists)}
	it { should validate_presence_of(:email) }

	it "shouldn't validate with password < 8 chars" do
		u = User.new(email: "foo@bar.com", password: "foo", password_confirmation: "foo")
		expect(u).to_not be_valid
	end

	it "shouldn't validate with mismatched passwords" do
		u = User.new(email: "foo@bar.com", password: "foo", password_confirmation: "bar")
		expect(u).to_not be_valid
	end

	it "should require valid email format" do
		u = User.new(email: "foo", password: "foobarbaz", password_confirmation: "foobarbaz")
		expect(u).to_not be_valid
	end

	it "should validate with correct email format and matching password >= 8 chars" do
		u = User.new(email: "foo@bar.com", password: "foobarbaz", password_confirmation: "foobarbaz")
		expect(u).to be_valid
	end
end
