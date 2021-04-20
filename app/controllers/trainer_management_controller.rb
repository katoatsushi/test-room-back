class TrainerManagementController < ApplicationController
    before_action :authenticate_v1_trainer!, only: [:all_customer, :my_requested_shift]

    def get_customer_records
        if v1_trainer_signed_in?
            # 今日以下のお客さんの予約を返す
            # today = Time.current.to_datetime
            t = Time.now
            today  = DateTime.new(t.year, t.month, t.day + 1)
            # todayを今日の終わりにする
            # initial_data = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id})
            #                 .where(appointments: {finish: false}).where("appointment_time <= ?",today)
            initial_data = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id}).where("appointment_time <= ?",today)
            initial_data_not_finish = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id}).where("appointment_time <= ?",today).where(appointments: {finish: false})
            initial_data_finish = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id}).where("appointment_time <= ?",today).where(appointments: {finish: true})
            initial_datas = {store: {store_name: "全ての店舗"}, all_data: initial_data, not_finish_data: initial_data_not_finish, finish_data: initial_data_finish}
            response = [initial_datas]
            Store.where(company_id: current_v1_trainer.company_id,deactivate: false).each do |s|
                res = {store: s}
                #　今日より前の終了していないアポ
                not_finish_data = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id})
                                .where(appointments: {finish: false}).where(appointments: {store_id: s.id})
                                .where("appointments.appointment_time <= ?",today)
                #　今月の終了したアポ
                finish_data = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id})
                .where(appointments: {finish: true})
                .where(appointments: {store_id: s.id})
                .where("appointments.appointment_time <= ?",today)
                #　今月の全てのアポ
                all_data = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id})
                .where(appointments: {store_id: s.id})
                .where("appointments.appointment_time <= ?",today)

                res[:finish_data] = finish_data
                res[:not_finish_data] = not_finish_data
                res[:all_data] = all_data
                response << res
            end
            # response << initial_datas
            render json: {
                data: response,
                intial_data: initial_data,
                # initial_datas: initial_datas,
                status: 200
            }
        end
    end

    def check_finished_record
        apointment_id = params["id"].to_i
        apo = Appointment.find(apointment_id)
        customer = apo.customer
        customer_record = apo.customer_record
        records_menues = customer_record.customer_record_session_menus
        render json: {
            customer: customer,
            apo: apo,
            record: customer_record,
            records_menues: records_menues,
            status: 200
        }
    end

    def record_delete
        if v1_trainer_signed_in?
            apo = Appointment.find(params["appointment_id"].to_i)
            customer_record = apo.customer_record
            record_menues = customer_record.customer_record_session_menus
            evaluation = customer_record.evaluation
            # customer_record_session_menusを削除
            record_menues.delete_all
            # evaluationを削除
            unless evaluation.nil?
                evaluation.delete
            end
            # customer_recordを削除
            customer_record.delete
            # appointmentのfinishをflaseに変更
            apo.finish = false
            apo.save
            render json: {
                message: "カルテの削除に成功しました",
                status: 200
            }
        else
            render json: {
                apo: "トレーナーはログインしてください",
                status: 200
            }
        end
    end

    def all_customer
        all_customers =  Customer.eager_load(:customer_status).eager_load(:customer_info).select("*").where(company_id: current_v1_trainer.company_id)
        render json: {
            error: false,
            all_customers: all_customers,
            status: 200
        }
    end

    def my_evaluation
        trainer_id = params["id"].to_i
        my_data = Appointment.includes(customer_record: :evaluation)
                                .where(customer_records: {trainer_id: trainer_id})
                                .group("appointments.fitness_name").average("evaluations.trainer_score")
        response = {details: "セッションメニューごとの評価平均点", name: my_data.keys, score: my_data.values}

        render json: {
            data:  response,
            status: 200
        }
    end

    def my_requested_shift
        # TODO トレーナーの既存のシフトを返す
        my_shifts = TrainerShift.where(trainer_id: current_v1_trainer.id)
        year = params["year"].to_i
        month = params["month"].to_i
        # binding.pry
        
    end
end

