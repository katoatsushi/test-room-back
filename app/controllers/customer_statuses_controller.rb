class CustomerStatusesController < ApplicationController
  before_action :set_customer_status, only: [:show, :destroy]

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
      customer_id = params[:id].to_i
      customer = Customer.find(params[:id].to_i)
      if customer.customer_status.nil?
        status = CustomerStatus.new(customer_id: customer_id)
      else
        status = customer.customer_status
      end

      if params["paid"] == "false"
        status.paid = false
      elsif params["paid"] == "true"
        status.paid = true
      end

      if params["room_plus"] == "false"
        status.room_plus = false
      elsif params["room_plus"] == "true"
        status.room_plus = true
      end

      status.dozen_sessions = params["dozen_sessions"]
      if params["numbers_of_contractnt"]
        status.numbers_of_contractnt = params["numbers_of_contractnt"]
      elsif
        status.numbers_of_contractnt = 0
      end
      error = "更新に失敗しました"
      customer = Customer.eager_load(:customer_status).eager_load(:customer_info).select("*").find_by(id: params[:id])
      
      if status.save
        render json: customer
      else
        render json: error
      end

      # if @customer_status.update(customer_status_params)
      #   customer = Customer.eager_load(:customer_status).eager_load(:customer_info).select("*").find_by(id: params[:id])
      #   render json: customer
      # else
      #   render json: @customer_status.errors, status: :unprocessable_entity
      # end
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
