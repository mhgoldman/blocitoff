class Api::ApiController < ApplicationController
	skip_before_action :verify_authenticity_token
	
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error	
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied_error

  respond_to :json 

  private

  def permission_denied_error
    error :forbidden, 'Permission denied'
  end

  def record_not_found_error
  	error :not_found, 'Record not found'
  end

  def error(status, message = 'Something went wrong')
    response = {
      errors: message
    }

    render json: response.to_json, status: status
  end

	def ensure_logged_in
		permission_denied_error and return unless user_signed_in?
	end  
end
