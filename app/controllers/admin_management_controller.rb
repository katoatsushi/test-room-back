class AdminManagementController < ApplicationController
    before_action :authenticate_v1_admin!, only: [:all_customer,:all_trainer]
  
    require 'date'

    def set_customer_status
        customer = Customer.find(params[:id])
    end

    def all_customer
        all_customers =  Customer.eager_load(:customer_status).
                        eager_load(:customer_info).select("*").
                        where(company_id: current_v1_admin.company_id)
        render json: {
            error: false,
            all_customers: all_customers,
            status: 200
        }
    end

    def get_trainer_shifts    
        company_id = params["company_id"].to_i
        stores = Store.where(company_id: company_id,deactivate: false)
        year = params["year"].to_i
        month = params["month"].to_i
        month = month
        end_date = Date.new(year, month, -1).day
        date_array= []
        date_infos = []
        (1..end_date).each do |d|
            date = DateTime.new(year, month, d, 0, 0,0, 0.375)
            date_infos << [d, %w(日 月 火 水 木 金 土)[date.wday]]
            date_array << d
        end

        data = []
        submit_data = []
        Trainer.where(company_id: company_id).each do |trainer|
            shifts_data = []
            date_array.each do |date|
                s = DateTime.new(year, month, date, 0, 0,0, 0.375)
                f = DateTime.new(year, month, date, -1, -1,0, 0.375)
                shifts = trainer.trainer_shifts.where("? <= start AND finish <= ?", s, f)
                if  shifts.length != 0
                    shifts = shifts[0]
                    shifts = shifts.attributes

                    if shifts["store_id"]
                        shifts["store"] = Store.find(shifts["store_id"])
                    end

                    submit_data << {trainer_id: trainer.id, day: date, day_ja:  %w(日 月 火 水 木 金 土)[s.wday], shifts: shifts}
                else
                    shifts = nil
                end
                shifts_data << {trainer: trainer, trainer_id: trainer.id, month: month, year: year, day: date, day_ja:  %w(日 月 火 水 木 金 土)[s.wday], shifts: shifts}
            end
            data << {trainer: trainer, data: shifts_data}
        end
        render json: {
            data: data,
            date_infos: date_infos,
            submit_data: submit_data,
            stores: stores,
            status: 200
        }
    end

    def update_trainer_shift
        datas = params["data"]
        
        datas.each do |d|
            if d["shifts"]["id"]
                # 変更の場合
                shift = TrainerShift.find(d["shifts"]["id"])
                shift.start = d["shifts"]["start"].to_datetime
                shift.finish = d["shifts"]["finish"].to_datetime
                if d["shifts"]["store"]
                    if d["shifts"]["store"]["id"]
                        shift.store_id = d["shifts"]["store"]["id"]
                    end
                end
                shift.save
            else
                # 新規の場合
                new_shift = TrainerShift.new
                new_shift.start = d["shifts"]["start"].to_datetime
                new_shift.finish = d["shifts"]["finish"].to_datetime
                new_shift.store_id = d["shifts"]["store"]["id"]
                new_shift.trainer_id = d["trainer_id"]
                new_shift.save
            end
        end
        
        if params["delete"].length > 0
            params["delete"].each do |d|
                TrainerShift.find(d).delete
            end
        end
    end

    def check_evaluation
        company_id = Customer.find(params["customer_id"]).company_id     
        evaluation_datas = Customer.joins(appointments: {customer_record: :evaluation}).select("*").where(appointments: {customer_id: params["customer_id"]})
        fitness_trainer_count_data = Customer.joins(appointments: {customer_record: :evaluation})
                                            .where(appointments: {customer_id: params["customer_id"]})
                                            .group("appointments.fitness_name").group("evaluations.trainer_name")
                                            .group("evaluations.trainer_score").count

        trainer_count_data = Customer.joins(appointments: {customer_record: :evaluation}).where(appointments: {customer_id: params["customer_id"]})
                                .group("evaluations.trainer_name").group("evaluations.trainer_score").count

        fitness_count_data = Customer.joins(appointments: {customer_record: :evaluation}).where(appointments: {customer_id: params["customer_id"]})
                                .group("appointments.fitness_name").group("evaluations.trainer_score").count
        fitness_trainer_ava_data = Customer.joins(appointments: {customer_record: :evaluation}).where(appointments: {customer_id: params["customer_id"]})
                                    .group("appointments.fitness_name").group("evaluations.trainer_name").average("evaluations.trainer_score")
        
        trainer_ava_data = Customer.joins(appointments: {customer_record: :evaluation}).where(appointments: {customer_id: params["customer_id"]})
                                .group("evaluations.trainer_name").average("evaluations.trainer_score")
        
        fitness_ava_data = Customer.joins(appointments: {customer_record: :evaluation}).where(appointments: {customer_id: params["customer_id"]})
                                .group("appointments.fitness_name").average("evaluations.trainer_score")
        each_menues_score_ava = []
        each_menues_score_count = []
        Fitness.where(company_id: company_id).each do |f|            
            res = Customer.joins(appointments: {customer_record: :evaluation}).where(appointments: {customer_id: params["customer_id"], fitness_id: f.id}).group("evaluations.trainer_name").average("evaluations.trainer_score")
            res_count = Customer.joins(appointments: {customer_record: :evaluation}).where(appointments: {customer_id: params["customer_id"], fitness_id: f.id}).group("evaluations.trainer_score").count
            each_menues_score_ava << ["#{f.name}におけるトレーナーごとのスコア平均点",f, res.keys, res.values]
            response = [['Task', 'Hours per Day']]
            res_count.keys.zip(res_count.values) do |k, v|
                response << [k.to_s + "点", v]
            end
            each_menues_score_count << ["#{f.name}におけるの点数ごとの割合",f, response]
        end
        fitness_trainer_count = [fitness_trainer_count_data.keys, fitness_trainer_count_data.values]
        trainer_count = [trainer_count_data.keys, trainer_count_data.values]
        fitness_count = [fitness_count_data.keys, fitness_count_data.values]
        fitness_trainer_ava = [fitness_trainer_ava_data.keys, fitness_trainer_ava_data.values]
        trainer_ava = ['全てのメニューにおけるトレーナーごとのスコア平均点', trainer_ava_data.keys, trainer_ava_data.values]
        fitness_ava = [fitness_ava_data.keys, fitness_ava_data.values]
        render json: {
            count: {all: each_menues_score_count,fitness_trainer: fitness_trainer_count, fitness: fitness_count, trainer: trainer_count},
            average: {all: each_menues_score_ava, fitness_trainer: fitness_trainer_ava, fitness: fitness_ava, trainer: trainer_ava},
            status: 200
        }
    end


    def search_customer
    end
    def all_trainer
        company_id = current_v1_admin.company_id
        trainers = Trainer.where(company_id: company_id)
        render json: {
            trainers: trainers,
            status: 200
        }
    end

end
