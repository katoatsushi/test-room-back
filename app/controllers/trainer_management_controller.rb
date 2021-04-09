class TrainerManagementController < ApplicationController
    before_action :authenticate_v1_trainer!, only: [:all_customer, :my_evaluation]

    def get_customer_records
        if v1_trainer_signed_in?
            # 今日以下のお客さんの予約を返す
            # today = Time.current.to_datetime
            t = Time.now
            today  = DateTime.new(t.year, t.month, t.day + 1)
            # todayを今日の終わりにする
            response = []
            initial_data = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id})
                            .where(appointments: {finish: false}).where("appointment_time <= ?",today)

            Store.where(company_id: current_v1_trainer.company_id,deactivate: false).each do |s|
                res = {store: s}
                #　今日より前の終了していないアポ
                not_finish_data = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id})
                                .where(appointments: {finish: false}).where(appointments: {store_id: s.id})
                                .where("appointment_time <= ?",today)
                #　今月の終了したアポ
                finish_data = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id})
                .where(appointments: {finish: true})
                .where(appointments: {store_id: s.id})
                .where("appointment_time >= ?", DateTime.new(DateTime.now.year, DateTime.now.month, 1,0, 0,0,0.375))
                #　今月の全てのアポ
                all_data = Customer.joins(:appointments).select("*").where(customers: {company_id: current_v1_trainer.company_id})
                .where(appointments: {store_id: s.id})
                .where("appointment_time >= ?", DateTime.new(DateTime.now.year, DateTime.now.month, 1, 0, 0,0,0.375))

                res[:finish_data] = finish_data
                res[:not_finish_data] = not_finish_data
                res[:all_data] = all_data

                response << res
            end
            render json: {
                data: response,
                intial_data: initial_data,
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
        my_data = Appointment.includes(customer_record: :evaluation)
                                .where(customer_records: {trainer_id: current_v1_trainer.id})
                                .group("appointments.fitness_name").average("evaluations.trainer_score")
        response = {details: "セッションメニューごとの評価平均点", name: my_data.keys, score: my_data.values}

        render json: {
            data:  response,
            status: 200
        }
    end
end

