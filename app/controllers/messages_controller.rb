class MessagesController < ApplicationController


def new
 @message = Message.new
end

def create
 @message = Message.new(message_params)
 @message.user_id = current_user.id
 @user = current_user

if @message.save
# mail="georgebardis1990@gmail.com"
 UserMailer.contact_email(@user).deliver_now
end
end



private
 def message_params
     params.require(:message).permit(:title,:msg)
 end
end
