class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :update, :destroy]
  # before_action :authenticate_v1_customer!
  def vacancy
    times = make_time_schedule_in_one_day(params[:year], params[:month], params[:day])
    response = []
    Store.where(company_id: params[:company_id]).each do |s|
      this_res = {store: s}
      schedule = []
      times.each do |t|
        apos = Appointment.where(store_id: s.id).where("appointment_time >= ? AND appointment_time < ?", t[0], t[1])
        admin_schedules = BlackSchedule.where(store_id: s.id).where("not_free_time_start< ? AND ? <= not_free_time_finish", t[0]+@training_time*60, t[1]-@training_time*60)
        vacancy_count = s.number_of_rooms - apos.length - admin_schedules.length
        if(t[0].min == 0)
          min_start = "00"
        else
          min_start = t[0].min.to_s
        end
        if(t[1].min == 0)
          min_fin = "00"
        else
          min_fin = t[1].min.to_s
        end
        schedule << {times: [[t[0].hour.to_s, min_start], [t[0].hour.to_s, min_fin]],vacancy_count: vacancy_count}
      end
      this_res[:schedule] = schedule
      response << this_res
    end
    render json: {
      message: "成功", 
      status: 200, 
      data: response, 
      stores: Store.where(company_id: params[:company_id])
    }
  end

  def new
    # /appointments/new/:store_id/:customer_menu_id/:year/:month/:day
    times = make_time_schedule_in_one_day(params[:year], params[:month], params[:day])
    fitness = Fitness.find(params["customer_menu_id"].to_i)
    store = Store.find(params["store_id"].to_i)
    trainers = Trainer.joins(:trainer_fitnesses).select("*").where(trainers: {company_id: fitness.company_id}).where(trainer_fitnesses: {fitness_id: fitness.id})
    @main = []
    times.each do |t|
      number_of_seats = 0
      trainers.each do |trainer|
        # TODO::トレーナーのシフトに店舗の概念があるのであれば、ここで店舗のWhereも行う
        number_of_seats +=  trainer.trainer_shifts.where("start <= ? AND  ? <= finish", t[0], t[1]).length
      end
      #　トレーナーの人数が部屋数を超えていた場合、部屋数を予約可能枠数とする
      number_of_seats > store.number_of_rooms  ? number_of_seats = store.number_of_rooms : number_of_seats
      number_of_reserved = Appointment.where(store_id: store.id, fitness_id: fitness.id).where("appointment_time >= ? AND appointment_time <= ?", t[0], t[1]).length
      number_of_admins = BlackSchedule.where(store_id: store.id)
        .merge((BlackSchedule.where("? < not_free_time_start AND not_free_time_start < ?", t[0], t[1]).or(BlackSchedule.where("? < not_free_time_finish AND not_free_time_finish < ?", t[0], t[1]))).or(BlackSchedule.where("not_free_time_start <= ? AND ? <= not_free_time_finish ", t[0], t[1]))).length
      free = number_of_seats - number_of_reserved - number_of_admins
      #　空き状況が0未満の際は0とする
      free < 0  ? free = 0 : free
      t[0].min == 0 ? start_min = "00" : start_min = t[0].min.to_s
      t[1].min == 0 ? finish_min = "00" : finish_min = t[1].min.to_s
      start_time = [t[0].hour.to_s, start_min]
      finish_time = [t[1].hour.to_s, finish_min]
      @main << [t, free, [start_time , finish_time]]
    end

    render json: @main
  end

  # POST /appointments
  def create
    @appointment = Appointment.new(appointment_params)
    store_id = params[:store_id].to_i
    customer_menu_id = params[:customer_menu_id].to_i
    @appointment.store_id = store_id
    @appointment.fitness_id = customer_menu_id
    @appointment.fitness_name = Fitness.find(customer_menu_id).name
    @appointment.customer_id = params[:customer_id]
    @appointment.appointment_time = DateTime.new(params["year"].to_i,params["month"].to_i, params["day"].to_i, params["hour"], params["min"], 0, 0.375)
    
    if !@appointment.customer_id.nil?
      if @appointment.save
        render json: @appointment
      else
        render json: @appointment.errors
      end
    else
      render json: 'error occured customer_id is nil, please cheack your header'
    end
  end

  # DELETE /appointments/1
  def destroy
    @appointmentment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointmentment = Appointment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def appointment_params
      params.require(:appointment)
      .permit(
        :appointment_time,
        :customer_id,
        :free_box,
        :store_id, 
        :customer_menu_id,
        :finish,
        :customer_menu_name
        )
    end
end
