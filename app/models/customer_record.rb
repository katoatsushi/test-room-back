class CustomerRecord < ApplicationRecord
    belongs_to :trainer
    belongs_to :appointment
    belongs_to :customer
    has_many :customer_record_session_menus
    has_one :evaluation
end
