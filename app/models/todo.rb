class Todo < ActiveRecord::Base
	belongs_to :user
	validates :user, presence: true
	validates :description, presence: true, allow_blank: false

	MAX_LIFETIME_IN_DAYS = 7

	def days_left
		MAX_LIFETIME_IN_DAYS - ((Time.now - created_at) / 60 / 60 / 24).to_i
	end

	def self.expired
		Todo.where("created_at < ?", MAX_LIFETIME_IN_DAYS.days.ago)
	end

	def self.delete_old_tasks
		# Todo.all.select {|t| t.expired?}.each {|t| t.delete}
		expired.delete_all
	end
end
