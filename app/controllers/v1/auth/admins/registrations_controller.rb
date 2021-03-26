class V1::Auth::Admins::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  
  def create
    if v1_master_admin_signed_in?
        @admin = Admin.new(configure_sign_up_params)
        super
        binding.pry
        if @admin.save
            render json: { model: 'admin',response:  @admin }
          # CustomerStatus.create(paid: false, room_plus: false, dozen_sessions: false, numbers_of_contractnt: 0, customer_id: @customer.id)
        end
    else
        render json: { response:  "if you create new acount of admin, please sign in as master account" } 
    end
  end

  protected
    def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:company_id])
    end
end
