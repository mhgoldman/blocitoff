class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  include Pundit

	after_action :verify_authorized, except: :index, unless: :exclude_from_verification?
	after_action :verify_policy_scoped, only: :index, unless: :exclude_from_verification?

	def exclude_from_verification?
		devise_controller? || params[:controller] == 'welcome'
	end
end
