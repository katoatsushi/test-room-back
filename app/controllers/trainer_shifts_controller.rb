class TrainerShiftsController < ApplicationController
    before_action :authenticate_v1_trainer!, only: [:create, :update]
    def create

        year = params["year"].to_i
        month = params["month"].to_i
        params[:trainer_shift].each{|day, value|
            if (!value["start"].nil? && !value["end"].nil?)
                start = DateTime.new(year, month, day.to_i,value["start"][0], value["start"][1], 0, 0.375)
                finish = DateTime.new(year, month, day.to_i,value["end"][0], value["end"][1], 0, 0.375)
                TrainerShift.create(start: start, finish: finish, trainer_id: current_v1_trainer.id)
            end
        }
    end

    def update
        year = params["year"].to_i
        month = params["month"].to_i
        params[:trainer_shift].each do |shift|
            if (shift["id"])
                trainer_shift = TrainerShift.find(shift["id"])
                if (shift["edit"])
                    if(shift["work"])
                        # シフトの時間変更
                        start = DateTime.new(year, month, shift["date"], shift["shift"]["start"][0], shift["shift"]["start"][1], 0, 0.375)
                        finish = DateTime.new(year, month, shift["date"], shift["shift"]["end"][0], shift["shift"]["end"][1], 0, 0.375)
                        trainer_shift.start = start
                        trainer_shift.finish = finish
                        trainer_shift.save
                    else # work
                        # シフトの削除
                        trainer_shift.delete
                    end # work
                end # edit
            else # id
                if(shift["new_shift"])
                    # 新規シフト願い
                    start = DateTime.new(year, month, shift["date"], shift["shift"]["start"][0], shift["shift"]["start"][1], 0, 0.375)
                    finish = DateTime.new(year, month, shift["date"], shift["shift"]["end"][0], shift["shift"]["end"][1], 0, 0.375)
                    this_day_start = DateTime.new(year, month, shift["date"], 0, 0, 0, 0.375)
                    this_day_finish = DateTime.new(year, month, shift["date"], 23, 59, 0, 0.375)
                    if (TrainerShift.where("? <= start AND finish <= ?", this_day_start, this_day_finish).length == 0)
                        TrainerShift.create(start: start, finish: finish, trainer_id: current_v1_trainer.id)
                    end
                end # new_shift
            end # id
        end
    end

end
