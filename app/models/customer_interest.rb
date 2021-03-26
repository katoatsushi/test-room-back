class CustomerInterest < ApplicationRecord
    belongs_to :customer
    belongs_to :interest
end
