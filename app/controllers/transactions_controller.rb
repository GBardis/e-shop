class TransactionsController < ApplicationController
  #  before_action :authenticate_user!
  before_action :check_cart!

  def new
    gon.client_token = generate_client_token
  end

  def create
    @result = if current_user.has_payment_info?
                Braintree::Transaction.sale(
                  amount: current_user.orders.last.subtotal,
                  payment_method_nonce: params[:payment_method_nonce],
                  options: {
                    # verify_card: true
                  },
                  device_data: params[:device_data]
                )
              else
                Braintree::Transaction.sale(
                  amount: current_user.orders.last.subtotal,
                  payment_method_nonce: params[:payment_method_nonce],
                  customer: {
                    first_name: params[:first_name],
                    last_name: params[:last_name],
                    shipping: params[:company],
                    postal_code: params[:postal_code],
                    email: current_user.email,
                    phone: params[:phone]

                  },
                  billing_address: {
                    street_address: '1 E Main St',
                    extended_address: 'Suite 3',
                    locality: 'Chicago',
                    region: 'IL'
                  },
                  options: {
                    verify_card: true,
                    store_in_vault_on_success: true
                  },
                  device_data: params[:device_data]
                )
              end

    if @result.success?
      current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
      # current_user.purchase_cart_movies!
      redirect_to root_url, notice: 'Congraulations! Your transaction has been successfully!'
    else
      flash[:alert] = 'Something went wrong while processing your transaction. Please try again!'
      gon.client_token = generate_client_token
      render :new
    end
  end

  def destroy
    @payment_method = Braintree::PaymentMethod.find(current_user.payment_method_token)
    @result = Braintree::PaymentMethod.delete(@payment_method)
  end

  private

  def check_cart!
    if current_user.orders.last.blank?
      redirect_to root_url, alert: 'Please add some items to your cart before processing your transaction!'
    end
  end

  def generate_client_token
    Braintree::ClientToken.generate
  end

  def generate_client_token
    if current_user.has_payment_info?
      Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
    else
      Braintree::ClientToken.generate
    end
  end
end
