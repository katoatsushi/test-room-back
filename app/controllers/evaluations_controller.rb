class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :update, :destroy]

  # GET /evaluations
  def index
    @evaluations = Evaluation.all

    render json: @evaluations
  end

  # GET /evaluations/1
  def show
    render json: @evaluation
  end

  # POST /evaluations
  def create
    
    @evaluation = Evaluation.new(evaluation_params)
    if @evaluation.save

      @records = CustomerRecord.where(customer_id: current_v1_customer.id).left_joins(:evaluation).where(evaluations: {id: nil})
      evaluation_all = []
      @records.each do |r|
        r.apo_time.min == 0 ? min = "00": min = r.apo_time.min
        record_info = {id: r.id, customer_id: r.customer_id, trainer_id: r.trainer_id, apo_time: r.apo_time, 
          year: r.apo_time.year.to_s, month: r.apo_time.month.to_s, day: r.apo_time.day.to_s,  hour: r.apo_time.hour.to_s,  min: min, detail: r.detail }
        menues = r.customer_record_session_menus
        menues_all = []
        menues.each do |m|
          menues_all <<  {
                customer_record_session_menu_id: m.id,
                time: m.time, 
                weight: m.weight,
                fitness_name: m.fitness_name, 
                fitness_third_name: m.fitness_third_name
              }
        end
        record_info["menues"] = menues_all
        evaluation_all << record_info
      end

      render :json => {
        :status => 200,
        :evaluations => evaluation_all,
        :data => @evaluation
      }
      
      # render json: @evaluation, status: 200, location: @evaluation
    else
      render json: @evaluation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /evaluations/1
  def update
    if @evaluation.update(evaluation_params)
      render json: @evaluation
    else
      render json: @evaluation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /evaluations/1
  def destroy
    @evaluation.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation
      @evaluation = Evaluation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def evaluation_params
      params.require(:evaluation).permit(:customer_id, :trainer_id, :customer_record_id, :food_score, :trainer_score)
    end
end
