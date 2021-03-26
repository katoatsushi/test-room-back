class FitnessThirdsController < ApplicationController
  before_action :set_fitness_third, only: [:show, :update, :destroy]

  # GET /fitness_thirds
  def index
    @fitness_thirds = FitnessThird.all

    render json: @fitness_thirds
  end

  # GET /fitness_thirds/1
  def show
    render json: @fitness_third
  end

  # POST /fitness_thirds
  def create
    @fitness_third = FitnessThird.new(fitness_third_params)

    if @fitness_third.save
      render json: @fitness_third, status: 200, location: @fitness_third
    else
      render json: @fitness_third.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fitness_thirds/1
  def update
    if @fitness_third.update(fitness_third_params)
      render json: @fitness_third
    else
      render json: @fitness_third.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fitness_thirds/1
  def destroy
    @fitness_third.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fitness_third
      @fitness_third = FitnessThird.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fitness_third_params
      params.fetch(:fitness_third, {})
    end
end
