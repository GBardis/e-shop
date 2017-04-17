class TransactionsController < ApplicationController
  #include Wicked::Wizard
  #steps :confirm_profile ,:transactions_details,:checkout
  before_action :check_cart!
  # before_action :validate_authorization_for_user
  def new_customer
    gon.client_token = generate_client_token
  end

  def create_customer
    session[:email] = params[:email]
    redirect_to new_transaction_path
  end
  # 1 or 0 in session explain if a user has shipping address ot not
  def new
    gon.client_token = generate_client_token
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
          session[:address] = 1
        end
      else
        session[:address] = 0
      end
    else
      session[:address] = 0
    end
  end

  def create
    @address_exists = session[:address]
    if current_user && !current_user.braintree_customer_id.nil? && @address_exists == 1
      @result =
      Braintree::Transaction.sale(
        amount: current_user.orders.last.subtotal,
        payment_method_nonce: params[:payment_method_nonce],
        customer_id: current_user.braintree_customer_id,
        shipping_address_id: params[:address],
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
        redirect_to root_url, notice: 'H Συναλλαγή σας ολοκληρώθηκε με επιτυχία'
        @order = Order.where(id: current_order.id, user_id: current_user.id)
        @order.update(status: 3)
      else
        flash[:alert] = 'Κάτα δεν πήγε καλά, προσπαθήστε ξανά!'
        gon.client_token = generate_client_token
        render :new
      end

    elsif current_user && !current_user.braintree_customer_id.nil? && @address_exists == 0

      @result =
      Braintree::Transaction.sale(
        amount: current_user.orders.last.subtotal,
        payment_method_nonce: params[:payment_method_nonce],
        shipping_address_id: params[:address],
        customer_id: current_user.braintree_customer_id,
        billing: {
          first_name: params[:first_name],
          last_name: params[:last_name],
          street_address: params[:street_address],
          postal_code: params[:postal_code],
          locality: params[:locality],
          region: params[:region]
        },
        :shipping => {
          first_name: params[:first_name],
          last_name: params[:last_name],
          street_address: params[:street_address],
          region: params[:region],
          locality: params[:locality],
          postal_code: params[:postal_code]
        },

        device_data: params[:device_data]
      )
      @result_address = Braintree::Address.create(
        customer_id: current_user.braintree_customer_id,
        first_name: params[:first_name],
        last_name: params[:last_name],
        street_address: params[:street_address],
        region: params[:region],
        locality: params[:locality],
        postal_code: params[:postal_code]
      )
      if @result_address.success?
        @user_current_address = current_user.addresses
        @user_current_address.create(address_id: @result_address.address.id, user_id: current_user.id)
      end
      if @result.success?
        redirect_to root_url, notice: 'H Συναλλαγή σας ολοκληρώθηκε με επιτυχία'
        # current_user.purchase_cart_movies!
      else
        flash[:alert] = 'Κάτα δεν πήγε καλά, προσπαθήστε ξανά!'
        gon.client_token = generate_client_token
        render :new
      end

    elsif current_user && current_user.braintree_customer_id.nil? && @address_exists == 0
      @result =Braintree::Customer.create(
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        phone: params[:phone]
      )
      @result_customer = @result.customer.id
      if @result.success?
        current_user.update(braintree_customer_id: @result_customer)
      end

      @result = Braintree::Transaction.sale(
        amount: current_order.subtotal,
        payment_method_nonce: params[:payment_method_nonce],
        customer_id: @result_customer,
        billing: {
          first_name: params[:first_name_ship],
          last_name: params[:last_name_ship],
          street_address: params[:street_address_ship],
          postal_code: params[:postal_code_ship],
          locality: params[:locality_ship],
          region: params[:region_ship]
        },
        shipping: {
          first_name: params[:first_name],
          last_name: params[:last_name],
          street_address: params[:street_address],
          region: params[:region],
          locality: params[:locality],
          postal_code: params[:postal_code]
        },

        device_data: params[:device_data]
      )
      @result_address = Braintree::Address.create(
        customer_id: @result_customer,
        first_name: params[:first_name],
        last_name: params[:last_name],
        street_address: params[:street_address],
        region: params[:region],
        locality: params[:locality],
        postal_code: params[:postal_code]
      )
      if @result_address.success?
        @user_current_address = current_user.addresses
        @user_current_address.create(address_id: @result_address.address.id, user_id: current_user.id)
      end
      if @result.success?
        redirect_to root_url, notice: 'H Συναλλαγή σας ολοκληρώθηκε με επιτυχία'
        # current_user.purchase_cart_movies!
      else
        flash[:alert] = 'Κάτα δεν πήγε καλά, προσπαθήστε ξανά!'
        gon.client_token = generate_client_token
        render :new
      end
    elsif !current_user
      @guest_user_email = session[:email]
      @result =Braintree::Customer.create(
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: @guest_user_email,
        phone: params[:phone]
      )
      @result_customer = @result.customer.id
      @result = Braintree::Transaction.sale(
        amount: current_order.subtotal,
        payment_method_nonce: params[:payment_method_nonce],
        customer_id: @result_customer,
        billing: {
          first_name: params[:first_name_ship],
          last_name: params[:last_name_ship],
          street_address: params[:street_address_ship],
          postal_code: params[:postal_code_ship],
          locality: params[:locality_ship],
          region: params[:region_ship]
        },
        shipping: {
          first_name: params[:first_name],
          last_name: params[:last_name],
          street_address: params[:street_address],
          region: params[:region],
          locality: params[:locality],
          postal_code: params[:postal_code]
        },

        device_data: params[:device_data]
      )

      session[:email] = nil
      if @result.success?
        #current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
        redirect_to root_url, notice: 'H Συναλλαγή σας ολοκληρώθηκε με επιτυχία'
        # current_user.purchase_cart_movies!
      else
        flash[:alert] = 'Κάτα δεν πήγε καλά, προσπαθήστε ξανά!'
        gon.client_token = generate_client_token
        render :new
      end
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
    Braintree::ClientToken.generate
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
