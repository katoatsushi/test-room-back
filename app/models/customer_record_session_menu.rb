class CustomerRecordSessionMenu < ApplicationRecord
    belongs_to :customer_record
    belongs_to :fitness_third
    belongs_to :fitness
end