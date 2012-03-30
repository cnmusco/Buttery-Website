class PublicController < ApplicationController
    include ParentsHelper
    
    def show_menu
        update_rgb
        @classes=Parent.find(:all, :order=>'class_of_food')
        @parents=Parent.find(:all, :order=>'rgb DESC')
        @makeups=Makeup.find(:all, :order=>'vital DESC')
        @ings1=Ingredient.all
        
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