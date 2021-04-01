class CustomerIndividualInfoController < ApplicationController
    def update_all
        if v1_customer_signed_in?
            MyCondition.create(customer_id: current_v1_customer.id ,height: params["condition"]["height"].to_f)
            CustomerWeight.create(customer_id: current_v1_customer.id ,weight: params["condition"]["weight"].to_f)
            customer_info = current_v1_customer.customer_info
            customer_info.job_id = params["jobs"]["id"]
            customer_info.job_name = Job.find(params["jobs"]["id"]).name
            customer_info.save
            # 全て削除
            current_v1_customer.customer_interests.delete_all
            params["interests"].each do |interest_id|
                CustomerInterest.create(customer_id: current_v1_customer.id, interest_id: interest_id)
            end
            interests = current_v1_customer.interests
            
            render json: {
                message: "プロフィールを変更しました！", 
                status: 200, 
                data: customer_info,
                interests: interests
              }
        else
            render json: {
                message: "ログインしてください、認証に失敗しました", 
              }
        end
    end
end
