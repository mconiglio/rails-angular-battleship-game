class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Check if the user is logged in and sends an unauthorized error if not.
  #
  # @return [void]
  def authenticate_user
    invalid_action unless current_or_guest_user
  end

  # Gets the logged user or a guest user otherwise.
  #
  # @return [User] the user logged or the guest user.
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        guest_user(false).reload.try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # Renders a JSON with an unauthorized message.
  #
  # @return [void]
  def invalid_action
    render json: { 'error': 'You have to authenticate to do this.' }, status: 401
  end

  private

  # Associates the games of the guest user to the new user / logged user.
  #
  # @return [void]
  def logging_in
    guest_user.games.update_all(user_id: current_user.id)
  end

  # Returns the current guest user or a new one if it doesn't exist.
  #
  # @param with_retry [Boolean] indicates if want to retry creating a new guest user
  #   when it doesn't find the current one.
  # @return [User] the existing guest user or the newly created one.
  def guest_user(with_retry = true)
    session[:guest_user_id] ||= create_guest_user.id
    @cached_guest_user ||= User.find(session[:guest_user_id])
  rescue ActiveRecord::RecordNotFound
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  # Creates a new guest user and saves its id on session.
  #
  # @return [User] the new guest user.
  def create_guest_user
    user = User.create(email: "guest_#{Time.now.to_i}#{rand(100)}@example.com")
    user.save!(validate: false)
    session[:guest_user_id] = user.id
    user
  end
end
