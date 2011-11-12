class PublicController < ApplicationController
    def show_menu
        parents=Parent.all
        parents.each do |parent|
            match=Makeup.where(:food => parent[:id])
            vit_flag=0  #flag for if vital ingredient is missing
            nv_flag=0   #flag for if non vital ingredient is missing
            nv_pres=0 # is a non-vital ingredient present
            are_there_vits=0
            
            match.each do |x|
                ingred=Ingredient.where(:id=>x[:ingredient])[0].amount_in_stock
                if x.vital==1
                    are_there_vits=1
                end
                if x.vital==0 && ingred!=0
                    nv_pres=1
                end
                if x.vital!=0 && ingred==0
                    vit_flag=1
                end
                if x.vital==0 && ingred==0
                    nv_flag=1
                end
            end
            
            if vit_flag==1 || (nv_pres==0 && are_there_vits==0)
                parent.update_attributes(:rgb=>0)
            elsif nv_flag!=0 && vit_flag==0
                parent.update_attributes(:rgb=>1)
            else
                parent.update_attributes(:rgb=>2)
            end
        end

        @classes=Parent.find(:all, :order=>'class_of_food')
        @parents=Parent.find(:all, :order=>'rgb DESC')
        @makeups=Makeup.find(:all, :order=>'vital DESC')
        
        #create array of ings with id as hash
        @ings=Array.new
        Ingredient.all.each do |ing|
            @ings[ing.id]=ing
        end
        
        #see how many orders there are
        orders=Order.all
        @order_counter=0
        orders.each do |ord|
            if ord.finished==0
                @order_counter+=1
            end
        end
    end
end