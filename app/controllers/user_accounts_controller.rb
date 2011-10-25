class UserAccountsController < ApplicationController
    include UserAccountsHelper
    
    def signup
        user=User.where(:email => params[:email])[0]
                                                                    #CHECK FO CASE OF USERNAME ALREADY EXISTING
        #email is not in db
        if user==nil
            render :update do |page|
                page<< '$("#invalid_login4").show();'
            end
            
        #if the user has been activated, they cannot re-signup
        elsif user[:activated]==1
            render :update do |page|
                page<< '$("#invalid_login3").show();'
            end
        
        #otherwise, enter the data in the db and send the email to activate account
        else
            hashed_pwd=hash_pwd(params[:pwd])
            
            render :update do |page|
                page<< "$('#email1').val('');"
                page<< "$('#pwd0').val('');"
                page<< "$('#pwd1').val('');"
                page<< "$('#username1').val('');"
                page<< '$("#sign_up_menu").slideUp("fast", function(){});'
                page<< 'alert("Thank You For Signing Up.  An Email Will Be Sent Shortly.\nPlease Follow Its Instructions");'
            end
            
            #send the email
            Notifier.signup_email(user).deliver
            
            #update the db
            user.username=params[:username]
            user.password=hashed_pwd
            user.save
        end
    end
    
    #controller for activation email
    def activation
        user=User.where(:username => params[:username])[0]
        
        if user==nil || Integer(user[:hash])!=Integer(params[:hash])
            render :update do |page|
                page<< "alert('Invalid Code');"
            end
        else
            user.activated=1
            user.save
                            #TODO ALSO LOG USER IN
        end
    end
    
    #controller for login
    def login
        user=User.where(:username => params[:username])[0]
        
        #is the username valid?  is the password correct?
        if user==nil || user[:password]!=hash_pwd(params[:pwd])
            render :update do |page|
                page<< '$("#invalid_login").show();'
            end
        #is the account active?
        elsif user[:activated]==0
            render :update do |page|
                page<< '$("#invalid_login5").show();'
            end
            Notifier.signup_email(user).deliver
            
        #log the user in
        else
            render :update do |page|
                page<< '$("#log_in_menu").slideUp("fast", function(){});'
                page<< "alert('welcome back '+ '#{user[:name]}');"
            end
        end
    end
end
