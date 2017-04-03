class TransactionsController < ApplicationController
  before_action :check_cart!
  # before_action :validate_authorization_for_user

  def new_customer
    gon.client_token = generate_client_token
  end

  def create_customer
    unless current_user
      @result = Braintree::Customer.create(
        id: gon.client_token,
        email: params[:email]
      )
      if @result.success?
        @user_id = @result.customer.id
        redirect_to new_transaction_path
      end
    end
  end

  def new
    gon.client_token = generate_client_token if current_user

    if current_user
      unless current_user.braintree_customer_id.nil?
        @addresses = Address.where(user_id: current_user.id)
        @user_addresses = []
        @addresses.each do |address|
          @result_find = Braintree::Address.find(
            current_user.braintree_customer_id,
            address.address_id
          )
          @user_addresses << @result_find
        end
      end
    end
  end

  def create
    @result =
      Braintree::Transaction.sale(
        amount: current_user.orders.last.subtotal,
        payment_method_nonce: params[:payment_method_nonce],
        shipping_address_id: params[:address],
        customer_id: current_user.braintree_customer_id,
        customer: {
          first_name: params[:first_name],
          last_name: params[:last_name],
          email: params[:email],
          phone: params[:phone]
        },
        billing: {
          first_name: params[:first_name],
          last_name: params[:last_name],
          street_address: params[:street_address],
          postal_code: params[:postal_code],
          locality: params[:locality],
          region: params[:region]
        },

        device_data: params[:device_data]
      )

    if @result.success?
      current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
      @payment_method = current_user.payment_methods_tokens
      @payment_method_token = PaymentMethodsToken.where(token: @result.transaction.credit_card_details.token)
      unless @payment_method_token.exists?
        @payment_method.create(token: @result.transaction.credit_card_details.token, user_id: current_user.id)
      end

      # current_user.purchase_cart_movies!
      redirect_to root_url, notice: 'Congraulations! Your transaction has been successfully!'
    else
      flash[:alert] = 'Something went wrong while processing your transaction. Please try again!'
      gon.client_token = generate_client_token
      render :new
    end
  end

  def destroy
    @result = Braintree::PaymentMethod.delete(current_user.braintree_customer_token)
    if @result.success?
      @result = nil
      current_user.update(braintree_customer_token: @result)
      redirect_to transactions_path
    else
      redirect_to transactions_path
    end
  end

  private

  def check_cart!
    if current_user
      if current_user.orders.last.blank?
        redirect_to root_url, alert: 'Please add some items to your cart before processing your transaction!'
      end
    elsif current_order.order_items.blank?
      redirect_to root_url, alert: 'Please add some items to your cart before processing your transaction!'
    end
  end

  def generate_client_token
    if current_user
      Braintree::ClientToken.generate if current_user.has_payment_info?
    else
      Braintree::ClientToken.generate
    end
  end

  def payment_method_token_params
    payment_method_token.require(:payment_method_token).permit(:token)
  end

  def validate_authorization_for_user
    unless current_user
      redirect_to new_user_session_path
      flash[:notice] = 'Πρέπει να συνδεθείτε για να μπορέσετε να συνεχίσετε στην αγορα ή να κάνετε μια νέα εγγραφή'
    end
  end
end
