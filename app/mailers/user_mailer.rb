class UserMailer < ApplicationMailer
    default from: 'mail@gmail.com'

    def contact_email(user)
        @user = user

        # RECIPIENT MAIL - STATIC
        mail = 'mail@gmail.com'
        mail(to: mail, subject: 'Sample Email')
    end

    def mailer(_user)
        @user = current_user
        mail(to: @user.email, subject: 'Sample Email')
    end
end
