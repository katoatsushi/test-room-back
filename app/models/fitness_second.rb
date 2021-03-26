class FitnessSecond < ApplicationRecord
    belongs_to :fitness
    has_many :fitness_thirds
end
