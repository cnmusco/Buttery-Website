class OrderController < ApplicationController
    
    before_filter :require_worker, :only=>[:view_order_queue]
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
    
    def record_not_found
        render :update do |page|
            page<< 'window.location="/worker/orders";'
            page<< 'alert("The Order Has Already Been Cancelled");'
        end
    end
    
    def require_worker
        unless session[:current_user] && session[:current_user].worker==1
            flash[:notice] = "UNAUTHORIZED ACCESS"
            redirect_to :root
        end
    end
    
    #adds order to the table
    def add_order
        cur_user=User.find(session[:current_user].id)
        if cur_user && params[:order]!='' && cur_user.ban==0
            Order.create(:name=>cur_user.name, :user_id=>cur_user.id, :order=>params[:order], :started=>0, :finished=>0)
            message='Order Successfully Placed'
        elsif cur_user.ban==1
            session[:current_user]=nil
            message='This Account Has Been Deactivated'
        elsif params[:order]!=''
            message='You Must Log In To Place An Order'
        else
            message='You Must Select Something To Make An Order'
        end
        render :update do |page|
            page<< 'window.location = "/home";'
        end
        flash[:notice]=message
    end
    
    #creates the actual queue to be displayed
    def view_order_queue
        ings=Ingredient.all
        @ings=Array.new
        ings.each do |ing|
            @ings[ing.id]=ing
        end
        
        flag=params[:flag]
        if flag
            flag=Integer(flag)
            
            #start order
            if flag==0
                ord=Order.find(params[:id])
                ord.update_attributes(:started=>1)
            
            #finish order
            elsif flag==1
                Order.find(params[:id]).update_attributes(:finished=>1)
                
            #pick up order
            elsif flag==2
                order=Order.find(params[:id])
                user=User.find(order.user_id)
                x=user.online_orders
                user.online_orders=x+1
                user.save
                Order.find(params[:id]).destroy
            
            #user never picked up order
            else
                order=Order.find(params[:id])
                user=User.find(order.user_id)
                user.ban=1
                x=user.warnings
                user.warnings=x+1
                user.save
                
                order=Order.where(:user_id => user.id).each do |ord|
                    ord.destroy
                end
            end
            render :update do |page|
                page<< 'window.location="/worker/orders";'
            end
        end
        
        #sort orders by so finished before started befire others
        orders=Order.find(:all, :order=>'started DESC')
        @orders=Array.new
        tmp=Array.new
        orders.each do |o|
            if o.finished==1
                @orders.push(o)
            else
                tmp.push(o)
            end
        end
        tmp.each do |t|
            @orders.push(t)
        end
    end
end
