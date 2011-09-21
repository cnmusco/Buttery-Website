class PublicController < ApplicationController
    def show_menu
        @classes=Parent.find(:all, :order=>'class_of_food')
        @parents=Parent.all
    end
end