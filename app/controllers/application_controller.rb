class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Check if the user is logged in and sends an unauthorized error if not.
  #
  # @return [void]
  def authenticate_user
    invalid_action unless user_signed_in?
  end

  # Renders a JSON with an unauthorized message
  #
  # @return [void]
  def invalid_action
    render json: { 'error': 'You have to authenticate to do this.' }, status: 401
  end
end
