class Users::SessionsController < Devise::SessionsController

  def create
    if params[:user][:email]
      @user = User.find_for_database_authentication(email: params[:user][:email])
      set_flash_message(:alert, :invalid)
      return render json: { 'error': flash[:alert] }, status: 401 unless @user && @user.valid_password?(params[:user][:password])
    else
      @user = warden.authenticate!(auth_options)
    end

    sign_in(@user, scope: :user)
    render json: current_or_guest_user
  end

  def destroy
    if user_signed_in?
      sign_out(@user)
      set_flash_message(:notice, :signed_out)
      render json: { 'message': flash[:notice] }, status: 200
    end
  end
end
