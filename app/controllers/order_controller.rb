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
            #subtract ingredients for order or give error message
            flag=1
            ings_to_sub=Array.new
            num_to_sub=Array.new
            ord=params[:order].split('|')
            ord.delete_at(0)
            ord.each do |o|
                c=o.split(',')
                c.delete_at(0)
                c.each do |a|
                    a=a.split(':')
                    num=Ingredient.find(a[0]).amount_in_stock
                    if (num-Integer(a[1]))<0
                        flag=0
                    else
                        ings_to_sub.push(Integer(a[0]))
                        num_to_sub.push(num-Integer(a[1]))
                    end
                end
            end
            
            if flag==1  #make substitutions
                Order.create(:name=>cur_user.name, :user_id=>cur_user.id, :order=>params[:order], :started=>0, :finished=>0)
                message='Order Successfully Placed'
                i=0
                ings_to_sub.each do |ing|
                    Ingredient.find(ing).update_attributes(:amount_in_stock => num_to_sub[i])
                    i+=1
                end
            else
                message='At Least One of The Requested Items Is No Longer In Stock'
            end
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
        @grills=Parent.where(:class_of_food => 'Grill')
        @mkups=Makeup.find(:all, :order=>'vital DESC')
        
        flag=params[:flag]
        if flag
            flag=Integer(flag)
            
            #start order
            if flag==0
                ord=Order.find(params[:id])
                ord.update_attributes(:started=>1)
                if ord.user_id
                    Notifier.order_ready(User.find(ord.user_id)).deliver
                end
            
            #finish order
            elsif flag==1
                Order.find(params[:id]).update_attributes(:finished=>1)
                
            #pick up order
            elsif flag==2
                order=Order.find(params[:id])
                if order.user_id
                    user=User.find(order.user_id)
                    x=user.online_orders
                    user.online_orders=x+1
                    user.save
                end
                Order.find(params[:id]).destroy
            
            #user never picked up order
            elsif flag==3
                order=Order.find(params[:id])
                if order.user_id
                    user=User.find(order.user_id)
                    user.ban=1
                    x=user.warnings
                    user.warnings=x+1
                    user.save
                
                    order=Order.where(:user_id => user.id).each do |ord|
                        ord.destroy
                    end
                else
                    order.destroy
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
            if o.finished==0
                @orders.push(o)
            else
                tmp.push(o)
            end
        end
        tmp.each do |t|
            @orders.push(t)
        end
    end
    
    
    #add a GRILL order from the worker page
    def add_manual_order
        #subtract ingredients for order or give error message
        flag=1
        ings_to_sub=Array.new
        num_to_sub=Array.new
        ord=params[:order].split('|')
        ord.delete_at(0)
        ord.each do |o|
            c=o.split(',')
            c.delete_at(0)
            c.each do |a|
                a=a.split(':')
                num=Ingredient.find(a[0]).amount_in_stock
                if (num-Integer(a[1]))<0
                    flag=0
                else
                    ings_to_sub.push(Integer(a[0]))
                    num_to_sub.push(num-Integer(a[1]))
                end
            end
        end
        
        if flag==1  #make substitutions
            Order.create(:name=>'face-to-face', :order=>params[:order], :started=>0, :finished=>0)
            message='Order Successfully Placed'
            i=0
            ings_to_sub.each do |ing|
                Ingredient.find(ing).update_attributes(:amount_in_stock => num_to_sub[i])
                i+=1
            end
        else
            message='At Least One of The Requested Items Is No Longer In Stock'
        end
        render :update do |page|
            page<< 'window.location = "/worker/orders";'
            page<< " alert('#{message}');"
        end
    end
end
