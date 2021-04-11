class StoresController < ApplicationController
  before_action :set_store, only: [:show, :update, :destroy]
  before_action :authenticate_v1_admin!, only: [:create, :update, :all, :deactivate]

  # GET /stores
  def index
    @company = Company.find(current_v1_admin.company_id)
    # @stores = Store.where(company_id: current_v1_admin.company_id,deactivate: false)
    @stores = Store.where(company_id: current_v1_admin.company_id)
    render json: {
      stores: @stores,
      company: @company
    }
  end

  # GET /stores/1
  def show
    render json: @store
  end

  # POST /stores
  def create
    @store = Store.new(store_params)
    @store.company_id = current_v1_admin.company_id
    if @store.save
      render json: @store, status: 200, location: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stores/1
  def update
    if @store.update(store_params)
      render json: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  def deactivate
    id = params[:id].to_i
    store = Store.find(id)
    store.deactivate = true
    store.save
  end

  # DELETE /stores/1
  def destroy
    @store.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def store_params
      params.require(:store).permit(:company_id, :number_of_rooms, :store_address, :store_name, :tel)
    end
end
