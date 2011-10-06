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
        @classes=Parent.find(:all, :order=>'class_of_food')
    end
    def add_ing
        id_new=Ingredient.last.id
        Ingredient.create(:id=>id_new+1, :ingredient_name=>params[:name], :amount_in_stock=>params[:amount], :unit_of_stock=>params[:unit])
    end
    def add_itm
        
    end
end