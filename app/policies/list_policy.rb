class ListPolicy < ApplicationPolicy
	attr_reader :user, :list

	def initialize(user, list)
		@user = user
		@list = list
	end

	def update?
		@user && ((@list.user == @user) || (@list.permissions == 'open'))
	end

	def edit?
		update?
	end

	def create?
		update?
	end

	def destroy?
		update?
	end

	def show?
		true
	end

	def index?
		true
	end

	#TODO NOT DRY
	class Scope < Scope
		def resolve
			if user
				scope.where("permissions IN ('open','viewable') OR user_id = ?", user.id)
			else
				scope.where("permissions IN ('open','viewable')")
			end
		end
	end	
end