class WorkerController < ApplicationController
    
    before_filter :require_worker
    
       
    def require_worker
        if session[:current_user] && session[:current_user].worker==0
            flash[:notice] = "UNAUTHORIZED ACCESS"
            redirect_to :root
        end
    end
    
    def update_inventory
        @ingredients=Array.new
        Ingredient.find(:all, :order=>'ingredient_name').each do |ing|
            @ingredients.push(ing)
        end
        @worker=Array.new
    end
    
    def manual
    end
    
    #inventory filters
    def up_inv1
        @ingredients=Array.new
        flag=params[:flag]
        misc=params[:misc_ing]
        
        #is the misc flag being used
        if misc=='none'
            ings=Ingredient.find(:all, :order=>'ingredient_name')
        else
            pars=Array.new
            ings=Array.new
            Parent.all.each do |par|
                if par.class_of_food == misc
                    pars.push(par.id)
                end
            end
            pars.each do |par|
                Makeup.where(:food=>par).each do |mkup|
                    ings.push(Ingredient.find(mkup.ingredient))
                end
            end
            ings=ings.sort_by{ |hsh| hsh[:ingredient_name]}
        end
        
        ings.each do |ing|
            #see if word matches and if filters match
            if /#{params[:word].downcase}/=~ing.ingredient_name.downcase && (flag=='0' || (flag=='1' && ing.amount_in_stock<ing.threshold) || (flag=='2' && ing.amount_in_stock==0))
                @ingredients.push(ing)
            end
        end
        if @ingredients.length>0
            render :partial => 'up_inv'
        end
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
    
    
    #send stocking email
    def restock
        ings=a=@ings=Ingredient.find(:all, :order=>'rank')
        restock=Array.new()
        ings.each do |ing|
            if ing.threshold >= ing.amount_in_stock && ing.threshold!=0
                restock.push(ing.ingredient_name)
            end
        end
        
        restock*=', '
        from=Array.new
        session[:current_user].name.split(' ').each do |n|
            from.push(n.capitalize)
            from.push(' ')
        end
        from=from.join()
        
        User.where(:worker => Integer(params[:to])).each do |to|
            Notifier.stock_email(restock, to.email, from).deliver
        end
        
        #alert user that task has been completed
        render :update do |page|
            page<< 'alert("Resocking Email Has Been Sent");'
        end
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
                Ingredient.create(:ingredient_name=>params[:name], :amount_in_stock=>params[:amount], :unit_of_stock=>params[:unit], :threshold=>params[:thresh], :rank=>params[:rank])
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