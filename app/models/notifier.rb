class Notifier < ActionMailer::Base
  default :from => "pierson-buttery"

      # send a signup email to the user, with the confirmation link
      def signup_email(user)
        mail( :to => user.email, 
              :subject => "Please Confirm Your Signup with the Buttery Web Site",
              :body => "/users_controls/activate_account/"+user.username+'/'+user.hash)
      end
  
    #send an email to reset pwd
    def reset_pwd(user)
        mail( :to => user.email, 
              :subject => "If You Have Lost Your Password, Please Click The Following Link",
              :body => "/account_controller/new_pwd/"+user.username+'/'+user.hash)
    end
    
    def stock_email(ings, address)        
        mail( :to => address, 
              :subject => "Stocking Email",
              :body => "Please get the following items before your shift tomorrow: "+ings)
    end
end