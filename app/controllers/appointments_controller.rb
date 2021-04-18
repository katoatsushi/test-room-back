class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :update, :destroy]
  before_action :authenticate_v1_customer!, only: [:destroy]
  def vacancy
    times = make_time_schedule_in_one_day(params[:year], params[:month], params[:day])
    response = []
    Store.where(company_id: params[:company_id],deactivate: false).each do |s|
      this_res = {store: s}
      schedule = []
      times.each do |t|
        apos = Appointment.where(store_id: s.id).where("appointment_time >= ? AND appointment_time < ?", t[0], t[1])
        admin_schedules = BlackSchedule.where(store_id: s.id).where("not_free_time_start< ? AND ? <= not_free_time_finish", t[0]+@training_time*60, t[1]-@training_time*60)
        # vacancy_count = s.number_of_rooms - apos.length - admin_schedules.length

        shifts_num = Trainer.joins(:trainer_shifts).select("*").where("start <= ? AND ? <= finish", t[0], t[1]).where(trainer_shifts: {store_id:  s.id}).where(company_id: 1).length
        vacancy_count = shifts_num - apos.length - admin_schedules.length
        # TrainerShift.joins(:trainers).select("*")
        t[0].min == 0? min_start = "00" : min_start = t[0].min.to_s
        t[1].min == 0? min_fin = "00" : min_fin = t[1].min.to_s
        schedule << {times: [[t[0].hour.to_s, min_start], [t[0].hour.to_s, min_fin]],vacancy_count: vacancy_count}
      end
      this_res[:schedule] = schedule
      response << this_res
    end
    render json: {
      message: "成功", 
      status: 200, 
      data: response, 
      stores: Store.where(company_id: params[:company_id],deactivate: false)
    }
  end

  def new  
    times = make_time_schedule_in_one_day(params[:year], params[:month], params[:day])
    fitness = Fitness.find(params["fitness_id"].to_i)
    store = Store.find(params["store_id"].to_i)
    response = []
    trainers = Trainer.where(company_id: fitness.company_id)

    times.each do |t|
      # 整体が予約されて、存在するトレーナーが[整体、トレーニング]をできる場合、このトレーナーの枠を使ってしまっているので新規顧客は予約をできない
      # 管理者のスケジュールを探す
      admins_reserved_count = BlackSchedule.where(store_id: store.id)
      .merge((BlackSchedule.where("? < not_free_time_start AND not_free_time_start < ?", t[0], t[1])
        .or(BlackSchedule.where("? < not_free_time_finish AND not_free_time_finish < ?", t[0], t[1])))
        .or(BlackSchedule.where("not_free_time_start <= ? AND ? <= not_free_time_finish ", t[0], t[1]))).count
       # トレーナーで今回のメニュー兼過去の予約のメニューを持っている者を抽出
      reserved_datas = Appointment.where(store_id: store.id).where(appointment_time: t[0])
      trainers_fitness_menu_ids = []
      reserved_menu_id = []
      trainers.each do |this_trainer|
        count = this_trainer.trainer_shifts.where("start <= ? AND ? <= finish", t[0], t[1]).where(store_id: store.id).count
        if count >= 1
          fitnesses_ids = []
          this_trainer.fitnesses.each do |f|
            fitnesses_ids << f.id
          end
          # 本時間に勤務予定のトレーナーの扱えるメニューを配列で取り込む
          trainers_fitness_menu_ids << fitnesses_ids
        end
      end
      # 部屋の可能使用数 = 部屋数-管理者のスケジュール数
      available_room_num = store.number_of_rooms - admins_reserved_count
      # トレーナのシフトの
      trainers_fitness_menu_len = trainers_fitness_menu_ids.length
      trainers_fitness_menu_len > available_room_num ? trainers_fitness_menu_len = available_room_num : trainers_fitness_menu_len

      if (reserved_datas.length != 0 )
        # すでに予約がある場合
        reserved_datas.each do |rdata|
          counter = 0
          trainers_fitness_menu_ids.each do |menu_ids|
            if(fitness.id != rdata.fitness_id)
              if (menu_ids.include?(rdata.fitness_id) && menu_ids.include?(fitness.id))
                trainers_fitness_menu_ids.delete_at(counter)
                trainers_fitness_menu_len = trainers_fitness_menu_len - 1
                break 
              end
            else
              trainers_fitness_menu_ids.delete_at(counter)
              trainers_fitness_menu_len = trainers_fitness_menu_len - 1
              break 
            end
            counter = counter + 1
          end
        end
        
      end

      # free = trainers_fitness_menu_len
      # number_of_seats = 0
      # reserved = 0
      # trainers.each do |trainer|
      #   ok = false
      #   # 要望のセッションメニューが当トレーナのできるセッションメニューに含まれているかのok
      #   trainer.fitnesses.each do |f|
      #     f.id == fitness.id ? ok = true : ok = false
      #   end
      #   if ok
      #     # 顧客様の希望店舗=トレーナーの指定日のシフトの店舗かつ希望セッションを行うことができる場合カウント
      #     number_of_seats +=  trainer.trainer_shifts.where("start <= ? AND  ? <= finish", t[0], t[1]).where(store_id:  store.id).count
      #   end
      # end
      # #　トレーナーの人数が部屋数を超えていた場合、部屋数を予約可能枠数とする
      # number_of_seats > store.number_of_rooms ? number_of_seats = store.number_of_rooms : number_of_seats
      # number_of_reserved = Appointment.where(store_id: store.id, fitness_id: fitness.id)
      #                                 .where(appointment_time: t[0]).count
      # number_of_admins = BlackSchedule.where(store_id: store.id)
      #   .merge((BlackSchedule.where("? < not_free_time_start AND not_free_time_start < ?", t[0], t[1])
      #     .or(BlackSchedule.where("? < not_free_time_finish AND not_free_time_finish < ?", t[0], t[1])))
      #     .or(BlackSchedule.where("not_free_time_start <= ? AND ? <= not_free_time_finish ", t[0], t[1]))).count
      # free = number_of_seats - number_of_reserved - number_of_admins
      # #　空き状況が0未満の際は0とする
      # free < 0  ? free = 0 : free
      t[0].min == 0 ? start_min = "00" : start_min = t[0].min.to_s
      t[1].min == 0 ? finish_min = "00" : finish_min = t[1].min.to_s
      start_time = [t[0].hour.to_s, start_min]
      finish_time = [t[1].hour.to_s, finish_min]
      response << [t, trainers_fitness_menu_len, [start_time , finish_time]]
    end

    render json: response
  end

  def create    
    @appointment = Appointment.new(appointment_params)
    store_id = params[:store_id].to_i
    fitness_id = params[:fitness_id].to_i
    customer = Customer.find(params[:customer_id])
    # 予約可能上限数
    customer_apos_max_num = customer.customer_status.numbers_of_contractnt
    # 予約をしようとした月の予約上限数
    this_month_start = DateTime.new(params["year"].to_i,params["month"].to_i, 1, 0, 0, 0, 0.375)
    this_month_end = DateTime.new(params["year"].to_i,params["month"].to_i, -1, 0, 0, 0, 0.375)
    apos_count = Appointment.where("? <= appointment_time AND appointment_time <= ? ", this_month_start, this_month_end)
                            .where(customer_id: customer.id).count

    # 1月の予約可能上限数を超えていないか    
    if apos_count >= customer_apos_max_num
      # render json: "今月の予約可能上限数を超えております"
      render :json => {
        :error => true, 
        :message => "今月の予約可能上限数を超えております"
      }
    else
      appointment_time = DateTime.new(params["year"].to_i,params["month"].to_i, params["day"].to_i, params["hour"], params["min"], 0, 0.375)
      @appointment.store_id = store_id
      @appointment.store_name = Store.find(store_id).store_name
      @appointment.fitness_id = fitness_id
      @appointment.fitness_name = Fitness.find(fitness_id).name
      @appointment.customer_id = params[:customer_id]
      @appointment.appointment_time = appointment_time
      
      if !@appointment.customer_id.nil?
        if @appointment.save
          # render json: @appointment
          render :json => {
            :error => false, 
            :data => @appointment
          }
        else
          # render json: @appointment.errors
          render :json => {
            :error => false, 
            :data => @appointment.errors
          }
        end
      else
        # render json: 'error occured customer_id is nil, please cheack your header'
        render :json => {
          :error => true, 
          :message => 'error occured customer_id is nil, please cheack your header'
        }
      end
    end
  end

  # DELETE /appointments/1
  def destroy
    @appointmentment.destroy
    render :json => {
      :error => false, 
      :message => '予約をキャンセルしました'
    }
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
        :store_name,
        :fitness,
        :fitness_name,
        :finish
        )
    end
end
