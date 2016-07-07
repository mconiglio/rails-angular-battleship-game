class Users::SessionsController < Devise::SessionsController

  def create
    @user = User.find_for_database_authentication(email: params[:user][:email])
    return invalid_login unless @user

    if @user.valid_password?(params[:user][:password])
      set_flash_message(:notice, :signed_in)
      sign_in(@user, scope: :user)
      render json: { 'message': flash[:notice] }, status: 200
    else
      invalid_login
    end
  end

  def destroy
    if user_signed_in?
      sign_out(@user)
      set_flash_message(:notice, :signed_out)
      render json: { 'message': flash[:notice] }, status: 200
    end
  end

  protected

  def invalid_login
    set_flash_message(:alert, :invalid)
    render json: { 'error': flash[:alert] }, status: 401
  end
end
