class AccountController < ApplicationController
    include UserAccountsHelper
    
    before_filter :require_login, :only=>[:main]
    def require_login
        unless session[:current_user] && session[:current_user].worker==1
            flash[:notice] = "You Need To Login To View This Page"
            redirect_to :root
        end
    end
    
    def main
        @user=session[:current_user]
    end
    
    def change_pwd
        cur_user=User.find(session[:current_user].id)
        
        #check if old pwd is correct
        if hash_pwd(params[:old_pwd])==cur_user.password
            cur_user.password=hash_pwd(params[:new_pwd])
            cur_user.save
            message="Password Successfully Updated"
        #otherwise
        else
            message="Incorrect Password"
        end
        
        render :update do |page|
            page << "$('#acc_old_pwd').val('');"
            page << "$('#acc_new_pwd1').val('');"
            page << "$('#acc_new_pwd2').val('');"
            page << "alert('#{message}');"
        end
    end
    
    #send the reset pwd email
    def reset_pwd
        user=User.where(:username => params[:username])[0]
        Notifier.reset_pwd(user).deliver
        render :update do |page|
            page<< '$("#log_in_menu").slideUp("fast", function(){});'
        end
            
    end
    
    #choose a new pwd
    def new_pwd
        user=User.where(:username => params[:username])[0]
        
        if user==nil || Integer(user[:hash])!=Integer(params[:hash])
            render :update do |page|
                page<< "alert('Invalid Code');"
            end
        else
            alphas=Array.new
            i=0
            ("a".."z").to_a.each do |l|
                alphas[i]=l
                i+=1
            end
            ("A".."Z").to_a.each do |l|
                alphas[i]=l
                i+=1
            end
            ("0".."9").to_a.each do |l|
                alphas[i]=l
                i+=1
            end
            
            @new_pwd= Array.new
            i=0
            while i<15
                @new_pwd[i]=alphas[rand(62)]
                i+=1
            end
            @new_pwd*=''
            user.password=hash_pwd(@new_pwd)
            user.save
            session[:current_user]=user
        end
    end
end
