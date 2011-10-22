class Notifier < ActionMailer::Base
  default :from => "pierson-buttery.heroku.com"

  # send a signup email to the user, pass in the user object that contains the user's email address
  def signup_email(user)
    mail( :to => user, 
          :subject => "Thanks for signing up" )
  end
end