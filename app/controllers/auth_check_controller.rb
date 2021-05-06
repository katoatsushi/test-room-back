class AuthCheckController < ApplicationController
    before_action :authenticate_v1_admin!, only: [:admin]
    before_action :authenticate_v1_customer!, only: [:customer]
    before_action :authenticate_v1_trainer!, only: [:trainer]
    before_action :authenticate_v1_master_admin!, only: [:master_admin]

    def customer
    end
    def trainer
    end
    def admin
    end
    def master_admin
    end
end
