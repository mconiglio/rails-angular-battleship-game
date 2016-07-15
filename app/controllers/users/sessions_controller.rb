class Users::SessionsController < Devise::SessionsController

  def create
    @user = warden.authenticate!(auth_options)
    sign_in(@user, scope: :user)
    render json: @user
  end

  def destroy
    if user_signed_in?
      sign_out(@user)
      set_flash_message(:notice, :signed_out)
      render json: { 'message': flash[:notice] }, status: 200
    end
  end
end
