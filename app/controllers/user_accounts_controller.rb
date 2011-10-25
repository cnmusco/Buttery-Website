class UserAccountsController < ApplicationController
    def signup
        user=User.where(:email => params[:email])[0]
        
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
            word='tvoeczlkttaudibgdvis lkttaudibgdvis tvogdvis '
            hashed_pwd=Array.new
            word1=Array.new
            word.each_byte do |b|
                word1.push(b)
            end
            
            i=0
            params[:pwd].each_byte do |b|
                hashed_pwd.push(b^word1[i])
                i+=1
            end
            hashed_pwd*=''
            
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
    def login
        
    end
end
