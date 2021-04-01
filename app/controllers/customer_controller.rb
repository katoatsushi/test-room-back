class CustomerController < ApplicationController
    def return_customers
        binding.pry
    end

    def update_interests
        if v1_customer_signed_in? 
            # interests = current_v1_customer.interests
            # interests.delete_all
            current_v1_customer.customer_interests.delete_all
            params["ids"].each do |id|
                CustomerInterest.create(customer_id: current_v1_customer.id, interest_id: id)
            end
            render json: {
                message: "基本情報を更新しました。", 
                status: 200, 
                interests:  current_v1_customer.interests
            }
          end
    end

    def get_company_id
        company_id = Company.first.id
        render json: {
            id: company_id
        }
    end
end
