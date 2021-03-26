class Fitness < ApplicationRecord
    belongs_to :company
    has_many :appointments
    has_many :fitness_seconds
    has_many :trainer_fitnesses
    has_many :trainers, through: :trainer_fitnesses
end
