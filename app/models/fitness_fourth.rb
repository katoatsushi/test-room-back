class FitnessFourth < ApplicationRecord
    belongs_to :fitness_third
    has_one :customer_record_session_menu
end
