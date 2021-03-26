class BlackSchedule < ApplicationRecord
    belongs_to :admin
    has_one :trial_session
end
