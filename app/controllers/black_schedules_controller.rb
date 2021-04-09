class BlackSchedulesController < ApplicationController
  before_action :set_black_schedule, only: [:show, :update, :destroy]
  before_action :authenticate_v1_admin!

  # GET /black_schedules
  def index
    @stores = Store.where(company_id: current_v1_admin.company_id,deactivate: false)
    @black_schedules = BlackSchedule.all
    render json: {
      stores: @stores, 
      black_schedule: @black_schedules
    }
  end

  # GET /black_schedules/1
  def show
    render json: @black_schedule
  end

  # POST /black_schedules
  def create
    @black_schedule = BlackSchedule.new(black_schedule_params)
    @black_schedule.admin_id = current_v1_admin.id
    @black_schedule.company_id = current_v1_admin.company_id
    start = DateTime.new(params["dayInfo"]["year"], params["dayInfo"]["month"], params["dayInfo"]["day"], params["timeStart"]["hour"], params["timeStart"]["min"], 0, 0.375)
    fin = DateTime.new(params["dayInfo"]["year"], params["dayInfo"]["month"], params["dayInfo"]["day"], params["timeFin"]["hour"], params["timeFin"]["min"], 0, 0.375)
    @black_schedule.not_free_time_start = start
    @black_schedule.not_free_time_finish = fin
    if @black_schedule.not_free_time_start >= @black_schedule.not_free_time_finish
      render json: '開始時刻は終了時刻よりも早い時間にしてください。'
    else
      if @black_schedule.save
        if params["customer_service"] == "true"
          trial = TrialSession.new(trial_session)
          trial.black_schedule_id = @black_schedule.id
          trial.save
        end
        render json: @black_schedule, status: 200, location: @black_schedule
      else
        render json: @black_schedule.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /black_schedules/1
  def update
    if @black_schedule.update(black_schedule_params)
      render json: @black_schedule
    else
      render json: @black_schedule.errors, status: :unprocessable_entity
    end
  end

  # DELETE /black_schedules/1
  def destroy
    @black_schedule.destroy
  end

  private
    def set_black_schedule
      @black_schedule = BlackSchedule.find(params[:id])
    end

    def black_schedule_params
      #params.fetch(:black_schedule, {})
      params.require(:black_schedule)
      .permit(
        # :not_free_time_start,
        # :not_free_time_finish,
        :customer_service,
        :store_id,
        :admin_id
        )
    end

    def trial_session
      params.require(:trial_session).permit(:name,:address,:tel,:email,:details)
    end
end