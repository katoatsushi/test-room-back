class TrainerInfosController < ApplicationController
  before_action :set_trainer_info, only: [:show, :update, :destroy]

  # GET /trainer_infos
  def index
    @trainer_infos = TrainerInfo.all

    render json: @trainer_infos
  end

  # GET /trainer_infos/1
  def show
    render json: @trainer_info
  end

  # POST /trainer_infos
  def create
    @trainer_info = TrainerInfo.new(trainer_info_params)

    if @trainer_info.save
      render json: @trainer_info, status: 200, location: @trainer_info
    else
      render json: @trainer_info.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trainer_infos/1
  def update
    if @trainer_info.update(trainer_info_params)
      render json: @trainer_info
    else
      render json: @trainer_info.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trainer_infos/1
  def destroy
    @trainer_info.destroy
  end

  def update_avatar
    if current_v1_trainer
      # TODO::ここなくす、その代わりにログイン後のチェック
      if current_v1_trainer.trainer_info.nil?
        TrainerInfo.create(trainer_id: current_v1_trainer.id)
      end
      
      trainer_info = current_v1_trainer.trainer_info
      # 既存の画像を削除
      if trainer_info.avatar.attached?
        trainer_info.avatar.purge
      end
    
      trainer_info.avatar.attach(params[:avatar])
      trainer_info.avatar_url = trainer_info.avatar.attachment.service.send(:object_for, trainer_info.avatar.key).public_url
      if trainer_info.save
        render json: {
          message: "プロフィール画像を変更しました！", 
          status: 200, 
          data: trainer_info
        }
      end
    else
      render json: {
        errors: "認証失敗です:ログインしてください", 
        status: 401
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trainer_info
      @trainer_info = TrainerInfo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def trainer_info_params
      params.fetch(:trainer_info, {})
    end
end
