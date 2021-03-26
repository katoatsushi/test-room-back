class TrainerController < ApplicationController
    def set_fitnesses
        trainer = params["trainer"]["data"]
        select_fitneses = params["fitness_data"]
        select_fitneses.each do |f|
            TrainerFitness.create(fitness_id: f["id"], trainer_id: trainer["id"])
        end
        render json: { response:  "成功" } 
    end

    def update_profile
        if v1_trainer_signed_in?
            trainer = current_v1_trainer
            trainer.first_name_kanji = params["name"]["first_name_kanji"]
            trainer.last_name_kanji = params["name"]["last_name_kanji"]
            trainer.first_name_kana = params["name"]["first_name_kana"]
            trainer.last_name_kana = params["name"]["last_name_kana"]
            trainer.gender = params["gender"]
            trainer.birthday = params["birthday"]
            trainer.phonenumber =  params["phoneNumber"]["nomal"]
            trainer.emergency_phonenumber =  params["phoneNumber"]["emergency"]
            trainer.save
        end 
    end
end
