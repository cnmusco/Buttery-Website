class Menu < ActiveRecord::Base
    has_many :ingredients
    belongs_to :parent
end
