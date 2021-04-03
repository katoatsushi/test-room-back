class CustomerRecordSessionMenusController < ApplicationController
  before_action :set_customer_record_session_menu, only: [:show, :update, :destroy]

  def index
    @customer_record_session_menus = CustomerRecordSessionMenu.all

    render json: @customer_record_session_menus
  end

  def new
    record = CustomerRecord.find(params[:customer_record_id])
    company_id = record.customer.company_id
    fitness = Fitness.where(company_id: company_id)
    menues = []
    fitness.each do |f|
      result_first = {id: f.id, name: f.name, second: nil}
      second_array = []
      f.fitness_seconds.each do |f2|
        result_second = {id: f2.id, name: f2.name, third: nil}
        second_array.append(result_second)
        third_array = []
        f2.fitness_thirds.each do |f3|
          result_third = {id: f3.id, name: f3.name}
          third_array.append(result_third)
          result_second[:third] = third_array
        end
        result_first[:second] = second_array
      end
      menues.append(result_first)
    end
    render json: {
      fitness_menues: menues,
     status: 200
    }
  end

  def show
    render json: @customer_record_session_menu
  end

  def create
    @customer_record_session_menu = CustomerRecordSessionMenu.new(customer_record_session_menu_params)
    @customer_record_session_menu.customer_record_id = params[:customer_record_id]
    @customer_record_session_menu.fitness_third_id = params[:fitness_third_id]
    @customer_record_session_menu.fitness_id = params[:fitness_id]
    @customer_record_session_menu.fitness_third_name = FitnessThird.find(params[:fitness_third_id]).name
    @customer_record_session_menu.fitness_name = Fitness.find(params[:fitness_id]).name
    if @customer_record_session_menu.save
      render json: @customer_record_session_menu, status: 200, location: @customer_record_session_menu
    else
      render json: @customer_record_session_menu.errors, status: :unprocessable_entity
    end
  end

  def create_record_and_menues
    
    if v1_trainer_signed_in?
    apo = params["customer_record_session_menu"]["apo"]
    # レコードを作成
    record = CustomerRecord.create(appointment_id: apo["id"], customer_id: apo["customer_id"], trainer_id: current_v1_trainer.id, apo_time: apo["appointment_time"], detail: params["customer_record_session_menu"]["message"])
    # アポを終了に変更
    this_apo = Appointment.find(apo["id"])
    this_apo.finish = true
    this_apo.save
    # レコードのメニューを作成
    params["customer_record_session_menu"]["data"].each do |data|
      CustomerRecordSessionMenu.create(time: data["time"],weight: data["weight"], fitness_third_id: data["data"]["id"],
                                      customer_record_id: record.id ,fitness_id: apo["fitness_id"],fitness_name: apo["fitness_name"],fitness_third_name: data["data"]["name"])
    end
    render json: record
    else
      render json: "トレーナーとしてログインしてください"
    end
  end

  # PATCH/PUT /customer_record_session_menus/1
  def update
    if @customer_record_session_menu.update(customer_record_session_menu_params)
      render json: @customer_record_session_menu
    else
      render json: @customer_record_session_menu.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customer_record_session_menus/1
  def destroy
    @customer_record_session_menu.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_record_session_menu
      @customer_record_session_menu = CustomerRecordSessionMenu.find(params[:id])
    end

    def customer_record_session_menu_params
      params.require(:customer_record_session_menu).permit(:time, :set_num, :fitness_id, :fitness_third_id, :fitness_third_name, :fitness_name,:customer_record_id, :detail) 
    end
end
