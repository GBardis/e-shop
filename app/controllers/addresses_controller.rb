class AddressesController < ApplicationController
  include AddressesHelper
  before_action :validate_authorization_for_user
  before_action :find_addresses
  before_action :page_title

  def new
    gon.client_token = generate_client_token
  end

  def create
    if current_user.braintree_customer_id.nil?
      @result = Braintree::Customer.create(
        first_name: current_user.name,
        last_name: current_user.lastname,
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
      addresses(@addresses)
      flash[:notice] = 'Η νέα διεύθυνση αποθηκεύτηκε'
    end

  end

  def index
    unless current_user.braintree_customer_id.nil?
      #addresses it is called from AddressesHelper
      addresses(@addresses)
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
    if @result.success?
      addresses(@addresses)
      flash[:notice] = "Η Διεύθυνση ενημερώθηκε"
    end
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
      addresses(@addresses)
      flash[:notice] = 'Η διεύθυνση διαγράφηκε'
    end

  end

  def validate_authorization_for_user
    if !current_user
      redirect_to new_user_session_path
      flash[:notice] = 'Δεν έχετε δικαίωμα προσπέλασης'
    end
  end

  private

  def page_title
    @meta_title = meta_title 'Διαχείριση Διευθύνσεων'
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
end
