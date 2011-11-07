class AccountController < ApplicationController
    include UserAccountsHelper
    
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
end
