class List < ActiveRecord::Base
	AVAIL_PERMISSIONS = ['open', 'viewable', 'private']
	
	has_many :todos, dependent: :destroy
	belongs_to :user
	validates :name, presence: true
	validates :user, presence: true
	validates :permissions, inclusion: {in: AVAIL_PERMISSIONS}
end
