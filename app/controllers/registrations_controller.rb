class RegistrationsController < Devise::RegistrationsController
  def create
     build_resource(sign_up_params)

     resource.save
     yield resource if block_given?
     if resource.persisted?
       if resource.active_for_authentication?
         set_flash_message! :notice, :signed_up
         sign_up(resource_name, resource)
           redirect_to cart_path 
       else
         set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
         expire_data_after_sign_in!
         respond_with resource, location: after_inactive_sign_up_path_for(resource)
       end
     else
       clean_up_passwords resource
       resource.errors.full_messages.each {|x| flash[x] = x} # Rails 4 simple way
       redirect_to cart_path
     end
  end
  private

  def sign_up_params
    params.require(:user).permit(:name, :lastname ,:email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :lastname, :email, :password, :password_confirmation, :current_password)
  end
end
