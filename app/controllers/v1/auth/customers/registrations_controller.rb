class V1::Auth::Customers::RegistrationsController < DeviseTokenAuth::RegistrationsController
    before_action :configure_sign_up_params
    # before_action :configure_permitted_parameters, if: :devise_controller?

    def new
        # @customer = Customer.new(configure_sign_up_params)
        super
    end

    def create
        @customer = Customer.new(configure_sign_up_params)
        super
        if @customer.save
            render json: { response:  @customer }
          # CustomerStatus.create(paid: false, room_plus: false, dozen_sessions: false, numbers_of_contractnt: 0, customer_id: @customer.id)
        end
    end


    protected
    
    def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:company_id, :first_name_kanji, :last_name_kanji, :first_name_kana, :last_name_kana])
    end
end
