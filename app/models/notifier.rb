class Notifier < ActionMailer::Base
  default :from => "pierson-buttery"

  # send a signup email to the user, with the confirmation link
  def signup_email(user)
    mail( :to => user.email, 
          :subject => "Please Confirm Your Signup with the Buttery Web Site",
          :body => "/users_controls/activate_account/"+user.username+'/'+user.hash)
  end
end