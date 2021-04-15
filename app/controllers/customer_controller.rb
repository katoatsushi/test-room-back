class CustomerController < ApplicationController
    def return_customers
        # binding.pry
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

    def after_login        
        customer_info = current_v1_customer.customer_info
        customer_status = current_v1_customer.customer_status
        customer_interests = current_v1_customer.interests

        @records = CustomerRecord.where(customer_id: current_v1_customer.id).left_joins(:evaluation).where(evaluations: {id: nil})
        evaluation_all = []
        @records.each do |r|
          r.apo_time.min == 0 ? min = "00": min = r.apo_time.min
          record_info = {id: r.id, customer_id: r.customer_id, trainer_id: r.trainer_id, apo_time: r.apo_time, 
            year: r.apo_time.year.to_s, month: r.apo_time.month.to_s, day: r.apo_time.day.to_s,  hour: r.apo_time.hour.to_s,  min: min, detail: r.detail }
          menues = r.customer_record_session_menus
          menues_all = []
          menues.each do |m|
            menues_all <<  {
                  customer_record_id: m.customer_record_id,
                  fitness_third_id: m.fitness_third_id,
                  time: m.time, 
                  weight: m.weight,
                  fitness_name: m.fitness_name, 
                  fitness_third_name: m.fitness_third_name,
                }
          end
          record_info["menues"] = menues_all
          evaluation_all << record_info
        end

        render :json => {
          :status => 200,
          :evaluations => evaluation_all,
          :customer_info => customer_info,
          :customer_status => customer_status,
          :customer_interests => customer_interests
        }
    end
end
