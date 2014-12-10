class TodoPolicy < ApplicationPolicy
	attr_reader :todo, :user

	def initialize(user, todo)
		@user = user
		@todo = todo
	end

	def create?
		@user && ((@todo.list.user == @user) || (@todo.list.permissions == 'open'))
	end

	def destroy?
		create?
	end

	class Scope < Scope
		def resolve
			if user
				scope.includes(:lists).where("permissions IN ('open','viewable') OR user_id = ?", user.id)
			else
				scope.includes(:lists).where("permissions IN ('open','viewable')")
			end
		end
	end
end