class Notifier < ActionMailer::Base
  default :from => "pierson-buttery"

      # send a signup email to the user, with the confirmation link
      def signup_email(user)
        mail( :to => user.email, 
              :subject => "Please Confirm Your Signup with the Buttery Web Site (" + Time.now.strftime("%b %d - %I:%M:%S %p") + ")",
              :body => "www.piersonbuttery.com/users_controls/activate_account/"+user.username+'/'+user.hash)
      end
  
    #send an email to reset pwd
    def reset_pwd(user)
        mail( :to => user.email, 
              :subject => "Buttery Password Reset (" + Time.now.strftime("%b %d - %I:%M:%S %p") + ")",
              :body => "If You Have Lost Your Password, Please Click The Following Link to Reset it
              www.piersonbuttery.com/account_controller/new_pwd/"+user.username+'/'+user.hash)
    end
    
    def stock_email(ings, ings2, address, from)        
        mail( :to => address, 
              :subject => "Stocking Email (" + Time.now.strftime("%b %d - %I:%M:%S %p") + ")",
              :body => "Please get the following items before your shift tomorrow: 
              "+ings + "\nAnd the following if they are in the freezer:\n
              "+ings2+"\n\nFrom,\n" + from)
    end
    
    def order_ready(user)
         mail( :to => user.email, 
              :subject => "Order Has Been Started (" + Time.now.strftime("%b %d - %I:%M:%S %p") + ")",
              :body => "Your order is being made.  It should be finished in a few minutes.")
    end
    
    def order_finished(user)
         mail( :to => user.email, 
              :subject => "Order Is Finished (" + Time.now.strftime("%b %d - %I:%M:%S %p") + ")",
              :body => "Your order is done.  Come down before it gets cold.")
    end
    
    def send_username(user)
       mail( :to => user.email, 
            :subject => "Your Pierson Butter Username " + Time.now.strftime("%b %d - %I:%M:%S %p") + "",
            :body => "Your username is: " + user.username)
    end
end