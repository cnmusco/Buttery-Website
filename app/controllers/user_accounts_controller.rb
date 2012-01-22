class UserAccountsController < ApplicationController
    include UserAccountsHelper
    
    def signup
        user=User.where(:email => params[:email])[0]
        usernamae_flag=0
        
        #check and see if username is already in use
        all_users=User.find(:all, :order=>'username DESC')
        all_users.each do |usr|
            break if usr[:username]==nil
            if usr[:username]==params[:username]
                usernamae_flag=1
            end
        end
        
        if usernamae_flag==1
            render :update do |page|
                page<< '$("#invalid_login3").show();'
            end
        #email is not in db
        elsif user==nil
            render :update do |page|
                page<< '$("#invalid_login4").show();'
            end
        
        #the email addres already has an active account
        elsif user[:activated]==1
            render :update do |page|
                page<< '$("#invalid_login6").show();'
            end
        
        #otherwise, enter the data in the db and send the email to activate account
        else
            hashed_pwd=hash_pwd(params[:pwd])
            
            render :update do |page|
                page<< "$('#email1').val('');"
                page<< "$('#pwd0').val('');"
                page<< "$('#pwd1').val('');"
                page<< "$('#username1').val('');"
                page<< '$("#sign_up_menu").toggle();'
                page<< 'alert("Thank You For Signing Up.  An Email Will Be Sent Shortly.\nPlease Follow Its Instructions");'
            end
            
            
            #update the db
            user.username=params[:username]
            user.password=hashed_pwd
            user.save
            
            #send the email
            Notifier.signup_email(user).deliver
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
            session[:current_user]=user
        end
    end
    
    #controller for login
    def login
        user=User.where(:username => params[:username])[0]
        
        #is the username valid?  is the password correct?
        if user==nil || user[:password]!=hash_pwd(params[:pwd])
            render :update do |page|
                page<< '$("#invalid_login").show();'
                page<< 'login_success = false;'
            end
        #is the user banned
        elsif user.ban==1
            render :update do |page|
                page<< '$("#invalid_login7").show();'
                page<< 'login_success = false;'
            end
        #is the account active?
        elsif user[:activated]==0
            render :update do |page|
                page<< '$("#invalid_login5").show();'
                page<< 'login_success = false;'
            end
            Notifier.signup_email(user).deliver
            
        #log the user in
        else
            render :update do |page|
                if user.worker != 0
                  page<< '$("#worker_li").show();'
                end
                page<< '$("#login_li").hide();'
                page<< '$("#signup_li").hide();'
                page<< 'login_success = true;'
                page<< "user_name = '#{user[:name].split.map{|x| x.capitalize}.join(" ")}';"
            end
            session[:current_user]=user
        end
        return true
    end
    
    #logs the user out
    def logout
        render :update do |page|
            page<< 'window.location = "/home";'
            page<< '$("#logged_in").toggle();'
  					page<< '$("#logged_out").toggle();'
  					page<< '$("#worker_li").hide();'
  					page<< '$("#login_li").show();'
            page<< '$("#signup_li").show();'
        end
        flash[:notice]='You Have Successfully Logged Out'
        session[:current_user]=nil
    end
end
