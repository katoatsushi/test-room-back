class V1::Auth::Trainers::RegistrationsController < DeviseTokenAuth::RegistrationsController
    before_action :configure_sign_up_params_for_trainer
    def new
      super
    end

    def create
        if v1_admin_signed_in?
            @trainer = Trainer.new(configure_sign_up_params_for_trainer)
            @trainer.company_id = current_v1_admin.company_id
            super
            # render json: { response:  @trainer, status: 200 }
        else
            render json: { response:  
              "管理者としてログインしてください。
              すでにログインされている場合は認証期間がすぎているため、
              ログアウトした後再度ログインし直してください" 
            } 
        end
      end

    protected

    def configure_sign_up_params_for_trainer
        devise_parameter_sanitizer.permit(:sign_up, keys: [:company_id, :first_name_kanji, :last_name_kanji, :first_name_kana, :last_name_kana])
    end
end
