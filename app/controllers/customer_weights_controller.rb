class CustomerWeightsController < ApplicationController
  before_action :set_customer_weight, only: [:show, :update, :destroy]

  # GET /customer_weights
  def index
    @customer_weights = CustomerWeight.where(customer_id: current_v1_customer.id)
    graph_data = []
    @customer_weights.each do |w|
      graph_data << { name: "#{w.created_at.month}/#{w.created_at.day}", uv: w.weight}
      # graph_data  << ["#{w.created_at.year}/#{w.created_at.month}/#{w.created_at.day}", w.weight]
    end 
    # render json: @customer_weights
    render json: graph_data
  end

  # GET /customer_weights/1
  def show
    render json: @customer_weight
  end

  # POST /customer_weights
  def create
    @customer_weight = CustomerWeight.new(customer_weight_params)
    @customer_weight.customer_id = current_v1_customer.id
    if @customer_weight.save
      render json: @customer_weight, status: :created, location: @customer_weight
    else
      render json: @customer_weight.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customer_weights/1
  def update
    if @customer_weight.update(customer_weight_params)
      render json: @customer_weight
    else
      render json: @customer_weight.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customer_weights/1
  def destroy
    @customer_weight.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_weight
      @customer_weight = CustomerWeight.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customer_weight_params
      params.require(:customer_weight).permit(:customer_id, :weight)
    end
end
