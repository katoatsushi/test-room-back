class MyConditionsController < ApplicationController
  before_action :set_my_condition, only: [:show, :update, :destroy]

  # GET /my_conditions
  def index
    @my_conditions = MyCondition.all

    render json: @my_conditions
  end

  # GET /my_conditions/1
  def show
    render json: @my_condition
  end

  # POST /my_conditions
  def create
    @my_condition = MyCondition.new(my_condition_params)

    if @my_condition.save
      render json: @my_condition, status: :created, location: @my_condition
    else
      render json: @my_condition.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /my_conditions/1
  def update
    if @my_condition.update(my_condition_params)
      render json: @my_condition
    else
      render json: @my_condition.errors, status: :unprocessable_entity
    end
  end

  # DELETE /my_conditions/1
  def destroy
    @my_condition.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_my_condition
      @my_condition = MyCondition.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def my_condition_params
      # params.require(:my_condition).permit(:customer_id, :weight, :height)
      params.require(:my_condition).permit(:customer_id, :height)
    end
end
