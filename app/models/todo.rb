class Todo < ActiveRecord::Base
	belongs_to :user
	validates :user, presence: true
	validates :description, presence: true, allow_blank: false

	def days_left
		7 - ((Time.now - created_at) / 60 / 60 / 24).to_i
	end

	def expired?
		days_left <= 0
	end
end
