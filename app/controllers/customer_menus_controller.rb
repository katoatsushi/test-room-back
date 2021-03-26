class CustomerMenusController < ApplicationController
  before_action :set_customer_menu, only: [:show, :update, :destroy]

  # GET /customer_menus
  def index
    @customer_menus = CustomerMenu.all

    render json: @customer_menus
  end

  # GET /customer_menus/1
  def show
    render json: @customer_menu
  end

  # POST /customer_menus
  def create
    @customer_menu = CustomerMenu.new(customer_menu_params)

    if @customer_menu.save
      render json: @customer_menu, status: 200, location: @customer_menu
    else
      render json: @customer_menu.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customer_menus/1
  def update
    if @customer_menu.update(customer_menu_params)
      render json: @customer_menu
    else
      render json: @customer_menu.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customer_menus/1
  def destroy
    @customer_menu.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_menu
      @customer_menu = CustomerMenu.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customer_menu_params
      params.fetch(:customer_menu, {})
    end
end
