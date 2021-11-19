class MessagesController < ApplicationController
   before_action :require_user 
   
   def create 
      message = current_user.messages.build(message_params)
      if message.save
         #redirect_to root_path  #what we want to do is to broadcast this message
         ActionCable.server.broadcast "chatroom_channel",
                                   # foo: message.body #it take the form of hash and riecived by the data in the chatroom.coffee.js
                                    mod_message: message_render(message)
      end
   end
   
   private
   
   def message_params
      params.require(:message).permit(:body) 
   end
   
   def message_render(message)
      render(partial: 'message', locals: {message: message})
   end
   
end