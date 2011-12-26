module OrderHelper
    def sendTxt(usr, msg)
        account_sid = 'AC6e7152cf2f804f229c135f2483c2dbd3'
        auth_token = '22b4d93743c59b6956000b13ba41857d'

        # set up a client to talk to the Twilio REST API
        @client = Twilio::REST::Client.new account_sid, auth_token
        
        num= '+1' + usr.phone_number1
        
        @client.account.sms.messages.create(
          :from => '+12033474283',
          :to => num,
          :body => msg
        )
    end
end
