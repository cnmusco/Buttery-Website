class WorkerController < ApplicationController
    def update_inventory
        @ingredients=Ingredient.all
    end
end