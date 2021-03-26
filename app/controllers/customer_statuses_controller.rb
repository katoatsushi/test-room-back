class CustomerStatusesController < ApplicationController
  before_action :set_customer_status, only: [:show, :update, :destroy]

  # GET /customer_statuses
  def index
    @customer_statuses = CustomerStatus.all

    render json: @customer_statuses
  end

  # GET /customer_statuses/1
  def show
    render json: @customer_status
  end

  # POST /customer_statuses
  def create
    @customer_status = CustomerStatus.new(customer_status_params)
    customer = Customer.find(params[:id])
    @customer_status.customer_id = customer.id
    if @customer_status.save
      render json: @customer_status, status: 200, location: @customer_status
    else
      render json: @customer_status.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customer_statuses/1
  def update
    if v1_admin_signed_in?
      # customer_id = params[:customer_id]
      if @customer_status.update(customer_status_params)
        customer = Customer.eager_load(:customer_status).eager_load(:customer_info).select("*").find_by(id: params[:id])
        render json: customer
      else
        render json: @customer_status.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /customer_statuses/1
  def destroy
    @customer_status.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_status
      @customer_status = CustomerStatus.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customer_status_params
      params.require(:customer_status).permit(:customer_id, :paid, :room_plus, :dozen_sessions, :numbers_of_contractnt)
    end
end
