class InterestsController < ApplicationController
    def create
        @interest = Interests.new(interest_params)
        if @interest.save
            render json: @interest
        end
    end
    def update
    end
    def destroy
    end
    def interest_params
        params.require(:interest)
        .permit(
            :name
          )
      end
end
