=begin
class CustomFailure < Devise::FailureApp
  def redirect_url
root_path
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    elsif warden_options[:recall]
      recall
    else
      redirect
      store_location!
      flash[:alert] = i18n_message unless flash[:notice]
    end
  end
end
=begin
