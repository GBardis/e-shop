class AddressesController < ApplicationController
  before_action :validate_authorization_for_user
  before_action :find_addresses

  def new; end

  def create
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
    @user_addresses = []
    @addresses.each do |address|
      @result = Braintree::Address.find(
        current_user.braintree_customer_id,
        address.address_id
      )
      @user_addresses << @result
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
    flash[:notice] = "Η διεύθυνση #{@result.address.street_address} διαγράφηκε".html_safe if @result.success?
  end

  def validate_authorization_for_user
    redirect_to new_user_session_path unless current_user
  end
end

private

def find_addresses
  @addresses = Address.where(user_id: current_user.id)
end

def address_params
  params.require(:address).permit(:user_id, :address_id)
end
