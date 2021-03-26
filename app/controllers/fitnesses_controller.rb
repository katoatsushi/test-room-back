class FitnessesController < ApplicationController
  before_action :set_fitness, only: [:show, :update, :destroy]

  # GET /fitnesses
  def index
    if v1_admin_signed_in?
      @fitnesses = Fitness.where(company_id: current_v1_admin.company_id)
      render json: {
        fitnesses: @fitnesses,
        status: 200
    }
    else
      render json: "管理者としてログインしてください"
    end
  end

  # GET /fitnesses/1
  def show
    render json: @fitness
  end

  def res_second
    res = []
    FitnessSecond.where(fitness_id: params[:id].to_i).each do |s|
      res << {second: s, third: s.fitness_thirds}
    end
    render json: {
      data: res,
      status: 200
    }
  end

  # POST /fitnesses
  def create
    @fitness = Fitness.new(fitness_params)

    if @fitness.save
      render json: @fitness, status: 200, location: @fitness
    else
      render json: @fitness.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fitnesses/1
  def update
    if @fitness.update(fitness_params)
      render json: @fitness
    else
      render json: @fitness.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fitnesses/1
  def destroy
    @fitness.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fitness
      @fitness = Fitness.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fitness_params
      params.fetch(:fitness, {})
    end
end
