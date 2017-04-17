class RegistrationsController < Devise::RegistrationsController
  after_action :create_order

  def create_order
    Order.new
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :lastname, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :lastname, :email, :password, :password_confirmation, :current_password)
  end
end
