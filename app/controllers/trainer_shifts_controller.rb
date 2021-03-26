class TrainerShiftsController < ApplicationController
    def create
        if v1_trainer_signed_in?
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
    end
end
