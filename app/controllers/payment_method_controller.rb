class PaymentMethodController < ApplicationController
  @customer = Braintree::Customer.find('a_customer_id')
  def update
    @result = Braintree::Customer.update(
      # id of customer to update
      first_name: 'New First Name',
      last_name: 'New Last Name'
    )
    if result.success?
      puts 'customer successfully updated'
    else
      p result.errors
    end
  end
end
