class List < ActiveRecord::Base
	AVAIL_PERMISSIONS = ['open', 'viewable', 'private']
	DEFAULT_PERMISSION = 'private'
	
	has_many :todos, dependent: :destroy
	belongs_to :user
	validates :name, presence: true
	validates :user, presence: true
	validates :permissions, inclusion: {in: AVAIL_PERMISSIONS}

	def self.publicly_visible
		List.where("permissions IN ('open','viewable')")
	end

	def self.visible_to(u=nil)
		if u.nil?
			publicly_visible
		else
			List.where("permissions IN ('open','viewable') OR user_id = ?", u.id)
		end
	end

	def self.editable_by(u=nil)
		if u.nil?
			List.none
		else
			List.where("permissions = 'open' OR user_id = ?", u.id)
		end
	end

	def editable_by?(u=nil)
		u && (permissions == 'open' || user == u)
	end

	def visible_to?(u=nil)
		['open','viewable'].include?(permissions) || (u && (user == u))
	end
end
