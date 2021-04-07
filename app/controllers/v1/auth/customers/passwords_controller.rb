class V1::Auth::Customers::PasswordsController < DeviseTokenAuth::PasswordsController
    before_action :validate_redirect_url_param, only: [:create, :edit]
    skip_after_action :update_auth_header, only: [:create, :edit]

    def create
        super
    end
    def new
        super 
    end
    # def edit
    #     super
    # end

    def edit
        # if a user is not found, return nil 
               
        @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])
        if @resource && @resource.reset_password_period_valid?
          token = @resource.create_token unless require_client_password_reset_token?
          @resource.skip_confirmation! if confirmable_enabled? && !@resource.confirmed_at
          @resource.allow_password_change = true if recoverable_enabled?
          @resource.save!
          yield @resource if block_given?
  
        #   if require_client_password_reset_token?
        #     redirect_to DeviseTokenAuth::Url.generate(@redirect_url, reset_password_token: resource_params[:reset_password_token])
        #   else
            redirect_header_options = { reset_password: true }
            redirect_headers = build_redirect_headers(token.token, token.client, redirect_header_options)
            @password_reset_redirect_url = @resource.build_auth_url(@redirect_url, redirect_headers)
            
            render :json => {
                :tokens => @resource.build_auth_url(@redirect_url, redirect_headers)
            }
            # redirect_to(@resource.build_auth_url(@redirect_url, redirect_headers))
          # end
        else
          render_edit_error
        end
    end

    def update
        super
    end

    def resource_params
        params.permit(:email, :reset_password_token)
    end

    protected


    def render_edit_error
        raise ActionController::RoutingError, 'Not Found'
    end

    def validate_redirect_url_param
        # give redirect value from params priority
        @redirect_url = params.fetch(
          :redirect_url,
          DeviseTokenAuth.default_password_reset_url
        )
  
        return render_create_error_missing_redirect_url unless @redirect_url
        return render_error_not_allowed_redirect_url if blacklisted_redirect_url?(@redirect_url)
    end
  
end