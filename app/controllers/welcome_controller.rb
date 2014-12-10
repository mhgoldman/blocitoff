class WelcomeController < ApplicationController
	before_filter :redirect_to_lists_page, only: :index

	def index
	end

	def about
	end

	private

	def redirect_to_lists_page
		redirect_to lists_path if user_signed_in?
	end
end