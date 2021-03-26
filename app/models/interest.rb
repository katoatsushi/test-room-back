class Interest < ApplicationRecord
    has_many :customer_interests
    has_many :customers, through: :customer_interests
end
