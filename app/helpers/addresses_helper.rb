module AddressesHelper
  def addresses(addresses = [])
    @user_addresses = []
    addresses.each do |address|
      @result = Braintree::Address.find(
        current_user.braintree_customer_id,
        address.address_id
      )
      @user_addresses << @result
    end
  end
end
