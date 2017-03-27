class PaymentMethodsController < ApplicationController
  before_action :find_payment_method

  def index
    @user_payment_methods = []
    @payment_methods.each do |payment_method|
      @result = Braintree::PaymentMethod.find(
        payment_method.token
      )
      @user_payment_methods << @result
    end
  end

  def edit
    @payment_method = Address.where(token: params[:id])
  end

  def find_payment_method
    @payment_methods = PaymentMethodsToken.where(user_id: current_user.id)
  end
end
