class CustomerConfirmationsController < ApplicationController
    # メール認証
    # 新規登録後、認証メールを開いた後の認証機能
    def check
        confirmation_token = params[:token]
        customer = Customer.find_by(confirmation_token: confirmation_token)
        if customer.nil?
            render json: nil, status: 500
        else
            customer.confirmed_at = DateTime.now
            # 会員情報を新規作成
            if customer.save
                if customer.customer_status.nil?
                    CustomerStatus.create(paid: false, room_plus: false, dozen_sessions: false, numbers_of_contractnt: 0, customer_id: customer.id)
                end
                if customer.customer_info.nil?
                    CustomerInfo.create(customer_id: customer.id)
                end
                render json: customer, status: 200
            else
                render json: nil, status: 500
            end
        end
    end
end
