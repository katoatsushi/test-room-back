class FitnessFourthsController < ApplicationController
  before_action :set_fitness_fourth, only: [:show, :update, :destroy]

  # GET /fitness_fourths
  def index
    @fitness_fourths = FitnessFourth.all

    render json: @fitness_fourths
  end

  # GET /fitness_fourths/1
  def show
    render json: @fitness_fourth
  end

  # POST /fitness_fourths
  def create
    @fitness_fourth = FitnessFourth.new(fitness_fourth_params)

    if @fitness_fourth.save
      render json: @fitness_fourth, status: 200, location: @fitness_fourth
    else
      render json: @fitness_fourth.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fitness_fourths/1
  def update
    if @fitness_fourth.update(fitness_fourth_params)
      render json: @fitness_fourth
    else
      render json: @fitness_fourth.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fitness_fourths/1
  def destroy
    @fitness_fourth.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fitness_fourth
      @fitness_fourth = FitnessFourth.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fitness_fourth_params
      params.fetch(:fitness_fourth, {})
    end
end
