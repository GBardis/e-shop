class ErrorsController < ApplicationController
  def error_404
    #  raise ActionController::RoutingError.new(params[:path])
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end
