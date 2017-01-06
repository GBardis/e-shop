class UserMailer < ApplicationMailer
 default from: "mail@gmail.com"

  def contact_email(user)
   @user = user

   #RECIPIENT MAIL - STATIC
   mail = 'georgebardis1990@gmail.com'
    mail(to: mail, subject: 'Sample Email')

  end


  def mailer(user)

    @user = current_user
    mail(to: @user.email, subject: 'Sample Email')
  end


end
