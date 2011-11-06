class WorkerController < ApplicationController
    
    before_filter :require_worker
       
    def require_worker
        unless session[:current_user] && session[:current_user].worker==1
        flash[:notice] = "UNAUTHORIZED ACCESS"
            redirect_to :root
        end
    end
    
    def update_inventory
        @ingredients=Ingredient.find(:all, :order=>'ingredient_name')
    end
    
    #controllers for changing the amount of inventory
    def add_inv
        tmp=Ingredient.find(params[:id]).amount_in_stock
        Ingredient.find(params[:id]).update_attributes(:amount_in_stock=>tmp+1)
        render :update do |page|
            page<< "$('#ais'+ing_id).html('#{Ingredient.find(params[:id]).amount_in_stock}');"
        end
    end
    def sub_inv
        tmp=Ingredient.find(params[:id]).amount_in_stock
        if tmp != 0
            Ingredient.find(params[:id]).update_attributes(:amount_in_stock=>tmp-1)
            render :update do |page|
                page<< "$('#ais'+ing_id).html('#{Ingredient.find(params[:id]).amount_in_stock}');"
            end
        else
        #return javascript
            render :update do |page|
                page<< '$("#ais"+ing_id).html(0+"");'
                page<< 'alert("The Ingredient Is Not Available");'
            end
        end
    end
    def empty_inv
        Ingredient.find(params[:id]).update_attributes(:amount_in_stock=>0)
    end
    
    #controler for menu manager
    def add_items
        if params[:flag]!=nil
        flag=Integer(params[:flag])
            if flag==2 #update item
                #remove ingredients from item
                params[:remove].split(';').each do |ings|
                    Makeup.all.each do |mkup|
                        if mkup.food==Integer(params[:current_item]) && mkup.ingredient==Integer(ings)
                            Makeup.find(mkup.id).destroy
                        end
                    end
                end
                
                #add ingredients to ingredient
                vits = Array.new
                params[:vits].split(';').each do |a|
                    vits.push(Integer(a))
                end
                
                params[:add].split(';').each do |ings|
                    Makeup.create(:vital => vits[Integer(ings)], :food => Integer(params[:current_item]), :ingredient => Integer(ings))
                end
            elsif flag==3
                num = Integer(params[:current_item])
                Parent.find(num).destroy
                Makeup.all.each do |mkup|
                    if mkup.food==num
                        Makeup.find(mkup.id).destroy
                    end
                end
            elsif flag==4
                Parent.create(:parent_name => params[:name], :class_of_food => params[:clas])
                id=Parent.last.id
                vit=params[:vits]
                vits=Array.new
                i=0
                vit.split(';').each do |a|
                    if a!= ''
                        vits[i]=Integer(a)
                    end
                    i+=1
                end
                i=0
                ings=Array.new
                params[:ings].split(';').each do |a|
                    ings[i]=Integer(a)
                    i+=1
                end
                ings.each do |ing|
                    Makeup.create(:vital => vits[ing], :ingredient => ing, :food=>id)
                end
            elsif flag==5
                Ingredient.create(:ingredient_name=>params[:name], :amount_in_stock=>params[:amount], :unit_of_stock=>params[:unit])
            end
        end

        @ings=Ingredient.find(:all, :order=>'ingredient_name')
        @ing_id=Ingredient.find(:all, :order=>'id')
        @classes=Parent.find(:all, :order=>'class_of_food')
        @menu_items=Parent.all
        @makeups=Makeup.all
        @current_item=Parent.first.id
        
        if params[:flag]!=nil
            if flag!=4
                @current_item=params[:current_item]
            end
            if flag==5
                render :partial => 'create_item'
            else
                render :partial => 'edit_item'
            end
        end
    end
end