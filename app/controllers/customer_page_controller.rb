class CustomerPageController < ApplicationController
  def index
    company_id = params[:company_id]
    @customers = Customer.all
  end

  # 終わったアポとこれからのアポの情報を返す
  def show
    @customer = Customer.find(params[:id])
    @customer_records = CustomerRecord.where(customer_id: params[:id])
    @array = []
    
    Appointment.where(customer_id: @customer.id).where(finish: true).each do |a|
      start = a.appointment_time
      finish = start + @training_time*60
      trainer = a.customer_record.trainer
      # 複数
      menues = a.customer_record.customer_record_session_menus
      fitness_menus = []
      menues.each do |m|
        fitness = m.fitness.name
        if !fitness_menus.include?(fitness) 
          fitness_menus << fitness
        end
      end
      if start.min == 0
        start_min = "00"
      else
        start_min = start.min.to_s
      end
      if finish.min == 0
        finish_min = "00"
      else
        finish_min = finish.min.to_s
      end
      init = {
        id: a.id, 
        trainer_id: trainer.id, 
        trainer_name: trainer.first_name_kanji + trainer.last_name_kanji, 
        appointment_date: [start.year, start.month, start.day],
        appointment_start: [start.hour.to_s, start_min], 
        appointment_finish: [finish.hour.to_s, finish_min],
        session_menus: fitness_menus
      } 
      @array << init
    end
    @appointments = []
    @apos = @customer.appointments.where(finish: false)
    @apos.each do |a|
      start = a.appointment_time
      finish = a.appointment_time + @training_time*60
      date = [a.appointment_time.year, a.appointment_time.month, a.appointment_time.day]
      if start.min == 0
        start = [start.hour.to_s, "00"]
      else
        start = [start.hour.to_s, start.min.to_s]
      end
      if finish.min == 0
        finish = [finish.hour.to_s, "00"]
      else
        finish =  [finish.hour.to_s, finish.min.to_s]
      end
      @appointments << {
        id: a.id,
        customer_id: a.customer_id,
        date: date,
        start: start,
        finish: finish,
        free_box: a.free_box,
        menu: a.fitness.name
      }
    end

    render :json => {
      :status => 200,
      :customer => @customer,
      :customer_records => @array,
      :appointments => @appointments
    }
  end

  def my_past_records

    if v1_customer_signed_in?
      records = current_v1_customer.appointments.where(finish: true)
      render :json => {
        :status => 200,
        :customer_records => records
      }
    end
  end

  def feedback_to_trainer
    #if v1_signed_in?
      # @records = CustomerRecord.where(customer_id: current_v1_customer.id).left_joins(:evaluation).where(evaluations: {id: nil})
      @records = CustomerRecord.where(customer_id: current_v1_customer.id).left_joins(:evaluation).where(evaluations: {id: nil})
      evaluation_all = []
      @records.each do |r|
        if r.apo_time.min == 0
          min = "00"
        else
          min = r.apo_time.min
        end
        record_info = {id: r.id, customer_id: r.customer_id, trainer_id: r.trainer_id, apo_time: r.apo_time, 
          year: r.apo_time.year.to_s, month: r.apo_time.month.to_s, day: r.apo_time.day.to_s,  hour: r.apo_time.hour.to_s,  min: min }
        menues = r.customer_record_session_menus
        menues_all = []
        menues.each do |m|
          menues_all <<  {
                time: m.time, 
                set_num: m.set_num,
                fitness_name: m.fitness_name, 
                fitness_third_name: m.fitness_third_name,
                detail: m.detail
              }
        end
        record_info["menues"] = menues_all
        evaluation_all << record_info
      end
      render :json => {
        :status => 200,
        :evaluations => evaluation_all,
      }
    # end # if v1_signed_in?
  end # def trainer_feedback
end
