class UserAccountsController < ApplicationController
    def signup
        user=User.where(:email => params[:email])
        
        #email is not in db
        if user==nil
            render :update do |page|
                page<< 'alert("invalid email address");'
            end
        #otherwise, enter the data in the db and send the email to activate account
        else
            user.update_attributes(:username => params[:username], :password => params[:pwd])
            
        end
    end
    def login
        
    end
end
