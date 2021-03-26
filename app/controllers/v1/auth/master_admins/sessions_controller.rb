class V1::Auth::MasterAdmins::SessionsController < DeviseTokenAuth::SessionsController
    def create
        super
    end
    
    def destroy
        super
    end
end
