class CustomerRecordsController < ApplicationController
  before_action :set_customer_record, only: [:show, :update, :destroy]

  # GET /customer_records
  def index
    @customer_records = CustomerRecord.all

    render json: @customer_records
  end

  def show
    render json: @customer_record
  end

  def create
      apo = Appointment.find(params[:appointment_id])
      @customer_record = CustomerRecord.new
      @customer_record.trainer_id = 1
      @customer_record.appointment_id = params[:appointment_id].to_i
      @customer_record.customer_id = params[:customer_id].to_i
      @customer_record.apo_time = apo.appointment_time
      if @customer_record.save
        apo.finish = true
        apo.save
        render json: @customer_record, status: 200
      else
        render json: @customer_record.errors, status: :unprocessable_entity
      end
  end

  def update
    if @customer_record.update(customer_record_params)
      render json: @customer_record
    else
      render json: @customer_record.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customer_records/1
  def destroy
    @customer_record.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_record
      @customer_record = CustomerRecord.find(params[:id])
    end

    def customer_record_params
      params.require(:customer_record).permit(:appointment_id, :customer_id, :trainer_id, :apo_time)
    end
end
