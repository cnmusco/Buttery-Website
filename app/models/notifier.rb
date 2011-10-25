class Notifier < ActionMailer::Base
  default :from => "pierson-buttery"

  # send a signup email to the user, pass in the user object that contains the user's email address
  def signup_email(user)
    mail( :to => user.email, 
          :subject => "Please Confirm Your Signup with the Buttery Web Site",
          :body => user.name+",\nplease click the following link to confirm your signup\n",
          :html => "<a href='users_controls/activate_account/'<%=user.username +'/'+ user.hash%>> click here to activate your account</a>")
          
  end
end