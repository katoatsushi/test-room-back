class FitnessSecondsController < ApplicationController
  before_action :set_fitness_second, only: [:show, :update, :destroy]

  # GET /fitness_seconds
  def index
    @fitness_seconds = FitnessSecond.all

    render json: @fitness_seconds
  end

  # GET /fitness_seconds/1
  def show
    render json: @fitness_second
  end

  # POST /fitness_seconds
  def create
    @fitness_second = FitnessSecond.new(fitness_second_params)

    if @fitness_second.save
      render json: @fitness_second, status: 200, location: @fitness_second
    else
      render json: @fitness_second.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fitness_seconds/1
  def update
    if @fitness_second.update(fitness_second_params)
      render json: @fitness_second
    else
      render json: @fitness_second.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fitness_seconds/1
  def destroy
    @fitness_second.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fitness_second
      @fitness_second = FitnessSecond.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fitness_second_params
      params.fetch(:fitness_second, {})
    end
end
