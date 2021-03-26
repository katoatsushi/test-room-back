class Appointment < ApplicationRecord
    belongs_to :customer
    has_one :customer_record
    belongs_to :fitness
end
