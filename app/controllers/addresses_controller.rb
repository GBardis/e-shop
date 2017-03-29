class AddressesController < ApplicationController
  before_action :validate_authorization_for_user
  before_action :find_addresses

  def new
    gon.client_token = generate_client_token
  end

  def create
    if current_user.braintree_customer_id.nil?
      @result = Braintree::Customer.create(
        id: gon.client_token,
        email: current_user.email
      )
      if @result.success?
        current_user.update(braintree_customer_id: @result.customer.id)
      end
    end
    @result = Braintree::Address.create(
      customer_id: current_user.braintree_customer_id,
      first_name: params[:first_name],
      last_name: params[:last_name],
      street_address: params[:street_address],
      region: params[:region],
      locality: params[:locality],
      postal_code: params[:postal_code]
    )
    if @result.success?
      @user_current_address = current_user.addresses
      @user_current_address.create(address_id: @result.address.id, user_id: current_user.id)

    end

    @user_addresses = []
    @addresses.each do |address|
      @result_find = Braintree::Address.find(
        current_user.braintree_customer_id,
        address.address_id
      )
      @user_addresses << @result_find
    end
    flash[:noitce] = 'Η νέα διεύθυνση αποθηκεύτηκε' if @result.success?
  end

  def show
    unless current_user.braintree_customer_id.nil?
      @user_addresses = []
      @addresses.each do |address|
        @result = Braintree::Address.find(
          current_user.braintree_customer_id,
          address.address_id
        )
        @user_addresses << @result
      end
    end
  end

  def edit
    @address_id = Address.where(address_id: params[:id])
    @address = Braintree::Address.find(
      current_user.braintree_customer_id,
      @address_id.first.address_id
    )
  end

  def update
    @address_id = Address.where(address_id: params[:id])
    @result = Braintree::Address.update(
      current_user.braintree_customer_id,
      @address_id.first.address_id,
      first_name: params[:first_name],
      last_name: params[:last_name],
      street_address: params[:street_address],
      region: params[:region],
      locality: params[:locality],
      postal_code: params[:postal_code]
    )
    @user_addresses = []
    @addresses.each do |address|
      @result_find = Braintree::Address.find(
        current_user.braintree_customer_id,
        address.address_id
      )
      @user_addresses << @result_find
    end
    flash[:notice] = "Η Διεύθυνση #{@result.address.street_address} ενημερώθηκε".html_safe if @result.success?
  end

  def delete
    @address = Address.where(address_id: params[:address_id])
  end

  def destroy
    @address = Address.where(address_id: params[:id])
    @result = Braintree::Address.delete(
      current_user.braintree_customer_id,
      @address.first.address_id
    )

    if @result.success?
      @address.first.delete
      @user_addresses = []
      @addresses.each do |address|
        @result_find = Braintree::Address.find(
          current_user.braintree_customer_id,
          address.address_id
        )
        @user_addresses << @result_find
      end
    end
    flash[:notice] = 'Η διεύθυνση διαγράφηκε' if @result.success?
  end

  def validate_authorization_for_user
    redirect_to new_user_session_path unless current_user
  end
end

private

def find_all_user_addresses
  @addresses = Address.where(user_id: current_user.id)
end

def generate_client_token
  if current_user.has_payment_info?
    Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  else
    Braintree::ClientToken.generate
  end
end

def find_addresses
  @addresses = Address.where(user_id: current_user.id)
end

def address_params
  params.require(:address).permit(:user_id, :address_id)
end
