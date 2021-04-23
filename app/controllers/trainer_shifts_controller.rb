class TrainerShiftsController < ApplicationController
    before_action :authenticate_v1_trainer!, only: [:create, :update]
    def create
        
        binding.pry
        
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
            if (shift["edit"])
                # 変更あり
                if(!shift["work"])
                    # シフトの削除
                    TrainerShift.find(shift["id"]).delete
                else
                    start = DateTime.new(year, month, shift["date"], shift["shift"]["start"][0], shift["shift"]["start"][1], 0, 0.375)
                    finish = DateTime.new(year, month, shift["date"], shift["shift"]["end"][0], shift["shift"]["end"][1], 0, 0.375)
                    if(shift["new_shift"])
                        # シフトの新規追加
                        TrainerShift.create(start: start, finish: finish, trainer_id: current_v1_trainer.id)
                    else
                        # 既存シフトの時間変更
                        # binding.pry
                        trainer_shift = TrainerShift.find(shift["id"])
                        trainer_shift.start = start
                        trainer_shift.finish = finish
                        trainer_shift.save
                    end
                end
            end
        end
    end

end
