class Users::RegistrationsController < Devise::RegistrationsController

  def create
    @user = User.new(user_params)

    if @user.save
      set_flash_message(:notice, :signed_up)
      sign_up(:user, @user)
      render json: @user, status: 201
    else
      set_flash_message(:alert, :invalid)
      render json: { 'error': flash[:alert] }, status: 401
    end
  end

  def update
    @user = User.find(current_user.id)

    if !@user.valid_password?(params[:user][:current_password])
      set_flash_message(:alert, :invalid_password)
      render json: { 'error': flash[:alert] }, status: 401
    else
      if @user.update(user_params)
        set_flash_message(:notice, :updated)
        sign_in(:user, @user)
        render json: @user, status: 200
      else
        set_flash_message(:alert, :invalid)
        render json: { 'error': flash[:alert] }, status: 401
      end
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
