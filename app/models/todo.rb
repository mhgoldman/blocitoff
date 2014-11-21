class Todo < ActiveRecord::Base
	belongs_to :user
	validates :user, presence: true
	validates :description, presence: true

	def days_left
		7 - ((Time.now - created_at) / 60 / 60 / 24).to_i
	end
end
