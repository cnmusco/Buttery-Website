class AccountController < ApplicationController
    include UserAccountsHelper
    
    before_filter :require_login, :only=>[:main]
    def require_login
        unless session[:current_user]
            flash[:notice] = "You Need To Login To View This Page"
            redirect_to :root
        end
    end
    
    def main
        @user=User.find(session[:current_user].id)
        @ords=Order.where(:user_id=>session[:current_user].id)
        
        if params[:reset]
            @user.phone_number1=nil
            @user.contact_options=0
            @user.save
        end
        if params[:number]
            @user.phone_number1=params[:number]
            @user.save
        end
        if params[:acc]
            @user.contact_options=params[:acc]
            @user.save
        end
        
        if @user.phone_number1
            @number=Array.new
            counter=0
            @number.push('(')
            @user.phone_number1.each_char do |x|
                @number.push(x)
                if counter==2
                    @number.push(') ')
                elsif counter==5
                    @number.push('-')
                end
                counter+=1
            end
        end
        
        ings=Ingredient.all
        @ings=Array.new
        ings.each do |ing|
            @ings[ing.id]=ing
        end
        
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
    
    
    #cancel an order
    def cancel_order
        ord=Order.find(params[:ord_id])
        if ord && ord.started==0
            #add the ingredients back to inventory
            ord1=ord.order.split('|')
            ord1.delete_at(0)
            ord1.each do |o|
                c=o.split(',')
                c.delete_at(0)
                c.each do |a|
                    a=a.split(':')
                    num=Ingredient.find(a[0]).amount_in_stock
                    Ingredient.find(Integer(a[0])).update_attributes(:amount_in_stock=>num+Integer(a[1]))
                end
            end
            
            ord.destroy
            message='Order Cancelled'
        #it is too late to cancel
        else
            message='It Is Too Late To Cancel'
        end
        flash[:message]=message
        render :update do |page|
            page<< "window.location='/account';"
        end
    end
    
    def send_username
      user = User.where(:email => params[:email])[0]
        
      if user==nil
            render :update do |page|
                page<< "alert('Email Not Recognized');"
            end
      elsif user[:username] == nil
        render :update do |page|
          page<< "alert('Email not yet registered for an account. Try Signing Up');"
          page<< "$('#send_username').hide();"
        end
      else
        Notifier.send_username(user).deliver
        render :update do |page|
            page<< "alert('An email containing your username has been sent.');"
            page<< "$('#send_username').hide();"
        end
      end
    end
    
end
