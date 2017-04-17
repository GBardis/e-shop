class SessionsController < Devise::SessionsController
  after_action :before_login
  def before_login
    Order.new
  end
end
