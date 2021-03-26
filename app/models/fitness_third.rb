class FitnessThird < ApplicationRecord
    belongs_to :fitness_second
    has_many :fitness_fourth
end
