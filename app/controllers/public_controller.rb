class PublicController < ApplicationController
    def show_menu
        @menus=Menu.all
    end
end