class TrainerInfo < ApplicationRecord
    belongs_to :trainer
    has_one_attached :avatar
end
