class WorkerController < ApplicationController
    def update_inventory
        @ingredients=Ingredient.find(:all, :order=>'ingredient_name')
    end
    
    #controllers for changing the amount of inventory
    def add_inv
        tmp=Ingredient.find(params[:id]).amount_in_stock
        Ingredient.find(params[:id]).update_attributes(:amount_in_stock=>tmp+1)
    end
    def sub_inv
        tmp=Ingredient.find(params[:id]).amount_in_stock
        if tmp != 0
            Ingredient.find(params[:id]).update_attributes(:amount_in_stock=>tmp-1)
        end
    end
    def empty_inv
        Ingredient.find(params[:id]).update_attributes(:amount_in_stock=>0)
    end
    
    #controler for add_items
    def add_items
        @ings=Ingredient.find(:all, :order=>'ingredient_name')
        @ing_id=Ingredient.find(:all, :order=>'id')
        @classes=Parent.find(:all, :order=>'class_of_food')
        @menu_items=Parent.all
        @makeups=Makeup.all
    end
    def add_ing
        Ingredient.create(:ingredient_name=>params[:name], :amount_in_stock=>params[:amount], :unit_of_stock=>params[:unit])
    end
    def add_itm
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
    end
    
    #controllers for viewing of ingredients in edit_parent
    def add_ing_to_itm
        @current_item=params[:current_item]
        if @current_item==-2
            @current_item=Parent.first.id
        end
        
        @ings=Ingredient.find(:all, :order=>'ingredient_name')
        @ing_id=Ingredient.find(:all, :order=>'id')
        @classes=Parent.find(:all, :order=>'class_of_food')
        @menu_items=Parent.all
        @makeups=Makeup.all
    end
end