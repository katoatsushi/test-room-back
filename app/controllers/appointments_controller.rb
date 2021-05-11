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

        shifts_num = Trainer.joins(:trainer_shifts).select("*").where("start <= ? AND ? <= finish", t[0], t[1]).where(trainer_shifts: {store_id:  s.id}).where(company_id: 1).length
        vacancy_count = shifts_num - apos.length - admin_schedules.length
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

  # def guidelines_of_new_function
  #   # 1 使える部屋数を決定
  #   if(部屋数 > 今回のメニューのシフト数)
  #     部屋数 = 今回のメニューのシフト数
  #   end
  #   部屋数 = 部屋数 - 管理者のスケジュール数 - お客様既存予約数
  #   # 2 対応可能なトレーナー数を計算±
  #   # 3 1と2の少ない方が予約可能数とする
  #   if(対応可能トレーナー数 > 部屋数)
  #     対応可能トレーナー数 = 部屋数
  #   end
  #   予約可能数 = 対応可能トレーナー数
  # end

  def check_only_vacancy(t, store)
    # 部屋数
    store_num = store.number_of_rooms
    # シフト数
    this_store_trainer_shifts = TrainerShift.where(store_id: store.id).where("start < ? AND ? < finish", t[0],  t[1])
    # 管理者のスケジュール
    admins_reserved = BlackSchedule.where(store_id: store.id).merge((BlackSchedule.where("? < not_free_time_start AND not_free_time_start < ?", t[0], t[1]).or(BlackSchedule.where("? < not_free_time_finish AND not_free_time_finish < ?", t[0], t[1]))).or(BlackSchedule.where("not_free_time_start <= ? AND ? <= not_free_time_finish ", t[0], t[1])))
    # 全てのお客様の予約
    reserved = Appointment.where(store_id: store.id).where(appointment_time: t[0])

    vacancy = [store_num ,this_store_trainer_shifts.length ].min
    vacancy = vacancy - reserved.length - admins_reserved.length
    
    return [t, vacancy]
  end

  def check_available_seat(t, store, params_fitness, customer)
    # 部屋数
    store_num = store.number_of_rooms
    # シフト数
    this_store_trainer_shifts = TrainerShift.where(store_id: store.id).where("start < ? AND ? < finish", t[0],  t[1]).all
    # 管理者のスケジュール
    admins_reserved = BlackSchedule.where(store_id: store.id).merge((BlackSchedule.where("? < not_free_time_start AND not_free_time_start < ?", t[0], t[1]).or(BlackSchedule.where("? < not_free_time_finish AND not_free_time_finish < ?", t[0], t[1]))).or(BlackSchedule.where("not_free_time_start <= ? AND ? <= not_free_time_finish ", t[0], t[1])))
    # 全てのお客様の予約
    reserved = Appointment.where(store_id: store.id).where(appointment_time: t[0])
    #　おんなじ時間に予約できないようにする
    this_customer_apo = Appointment.where(customer_id: customer.id).where(appointment_time: t[0])
    if(this_customer_apo.length!=0)
      return 0
    end

    full_time_not_have = []
    full_time_have = []
    part_time_jobs = []
    this_store_trainer_shifts.each do |shift|
      # セッションメニューを配列で持つ
      if(shift.trainer.full_time)
        if(shift.trainer.fitnesses.ids.include?(params_fitness.id))
          # 正社員で希望セッションを扱える
          full_time_have.append(shift.trainer.fitnesses)
        else
          # 正社員で希望セッションを扱えない
          full_time_not_have.append(shift.trainer.fitnesses)
        end
      else
        part_time_jobs.append(shift.trainer.fitnesses)
      end
    end
    
    # シフトを扱えるメニュー数ごとにソート
    full_time_have = full_time_have.sort_by { |x| x.length }
    full_time_not_have = full_time_not_have.sort_by { |x| x.length }

    # 体験のお客様ためトレーナーが入りシフトが削除
    admins_reserved.each do |admin|
      admin_roop_counter = 0
      if(admin.trial_session) # a
        if(full_time_not_have.length != 0) # b
          full_time_not_have.delete_at(admin_roop_counter)
        else # b
          if(full_time_have.length != 0) # c
            full_time_have.delete_at(admin_roop_counter)
          end # c
        end # b
      end # a
      admin_roop_counter = admin_roop_counter + 1
    end

    
    available_menues = full_time_not_have + full_time_have + part_time_jobs
    available_menues_array = available_menues.sort_by { |x| x.length }

    # 既存の予約のお客様の予約とシフトの相殺
    reserved.each do |r|
      roop_counter = 0
      available_menues_array.each do |menues|
        if menues.ids.include?(r.fitness_id)
          available_menues_array.delete_at(roop_counter)
          break
        end
        roop_counter = roop_counter + 1
      end
    end

    # 希望メニューに対する、現在稼働可能なトレーナーの人数
    reservation_available = 0
    available_menues_array.each do |menues|
      if menues.ids.include?(params_fitness.id)
        reservation_available = reservation_available + 1
      end
    end
    # 空いている部屋数と可能なトレーナー数の少ない方が予約可能数
    reservation_available = [store_num - admins_reserved.count - reserved.count, reservation_available].min
    return reservation_available
  end

  def new  
    times = make_time_schedule_in_one_day(params[:year], params[:month], params[:day])
    fitness = Fitness.find(params["fitness_id"].to_i)
    store = Store.find(params["store_id"].to_i)
    response = []
    # trainers = Trainer.where(company_id: fitness.company_id)
    customer = Customer.find(params[:customer_id])
    
    times.each do |t|
      # available_num = check_available_seat(t, store, trainers, fitness, customer)
      available_num = check_available_seat(t, store,  fitness, customer)
      t[0].min == 0 ? start_min = "00" : start_min = t[0].min.to_s
      t[1].min == 0 ? finish_min = "00" : finish_min = t[1].min.to_s
      start_time = [t[0].hour.to_s, start_min]
      finish_time = [t[1].hour.to_s, finish_min]
      response << [t, available_num, [start_time , finish_time]]
    end
    render :json => {
      :store => store,
      :fitness => fitness,
      :data => response
    }
    # render json: response
  end

  def create
    @appointment = Appointment.new(appointment_params)
    store = Store.find(params[:store_id].to_i)
    fitness = Fitness.find(params[:fitness_id].to_i)
    customer = Customer.find(params[:customer_id])
    # タイムゾーンを指定
    appointment_time = Time.new(params["year"].to_i,params["month"].to_i, params["day"].to_i, params["hour"], params["min"], 0,'+09:00')  
    # 現在予約できるか確認
    t = [appointment_time, appointment_time + @training_time*60]
    # 予約可能数がなければリターン
    available = check_available_seat(t, store, fitness, customer)
    # 予約可能上限数
    customer_apos_max_num = customer.customer_status.numbers_of_contractnt
    this_month_start = DateTime.new(params["year"].to_i,params["month"].to_i, 1, 0, 0, 0, 0.375)
    this_month_end = DateTime.new(params["year"].to_i,params["month"].to_i, -1, 0, 0, 0, 0.375)
    # 今月の総予約数
    apos_count = Appointment.where("? <= appointment_time AND appointment_time <= ? ", this_month_start, this_month_end)
                            .where(customer_id: customer.id).count
    if(customer_apos_max_num < apos_count)
      message = "今月の予約上限を超えています。"
    end
    if(available <= 0)
      message = "空き予約が埋まってしまったため、予約に失敗してしまいました"
    end
    # 1月の予約可能上限数を超えていないか
    if ((customer_apos_max_num > apos_count) && (available > 0))
      appointment_time = DateTime.new(params["year"].to_i,params["month"].to_i, params["day"].to_i, params["hour"], params["min"], 0, 0.375)
      @appointment.store_id = store.id
      @appointment.store_name = store.store_name
      @appointment.fitness_id = fitness.id
      @appointment.fitness_name = fitness.name
      @appointment.customer_id = params[:customer_id]
      @appointment.appointment_time = appointment_time
      
      if !@appointment.customer_id.nil?
        if @appointment.save
          render :json => {
            :error => false, 
            :data => @appointment
          }
        else
          render :json => {
            :error => false, 
            :data => @appointment.errors
          }
        end
      else
        render :json => {
          :error => true, 
          :message => 'error occured customer_id is nil, please cheack your header'
        }
      end
    else
      render :json => {
        :error => true, 
        :message => message
      }
    end
  end

  def room_plus
    comapny_id = params[:id]
    t = Time.now 
    today = admin_make_time_schedule(t.year, t.month, t.day)
    tmo = Time.now + 60*60*24
    tomorrow = admin_make_time_schedule(tmo.year, tmo.month, tmo.day)
    stores = Store.where(company_id: comapny_id)
    response = []
    
    stores.each do |s|
      availables = []
      today.each do |t|
        available = check_only_vacancy(t, s)
        availables.append(available)
      end
      response.append({month: today[0][0].month, day: today[0][0].day, store_name: s, data: availables})
    end

    stores.each do |s|
      availables = []
      tomorrow.each do |at|
        available = check_only_vacancy(at, s)
        availables.append(available)
      end
      response.append({month: tomorrow[0][0].month, day: tomorrow[0][0].day, store_name: s, data: availables})
    end
    render :json => {
      :error => false,
      :message => "roomプラスのご予約はLINEにて承ります",
      :data => response
    }
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