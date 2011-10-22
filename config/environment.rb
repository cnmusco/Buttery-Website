# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Buttery::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => "app930642@heroku.com",
  :password => "yrt7zffp",
  :domain => "pierson-buttery.heroku.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}