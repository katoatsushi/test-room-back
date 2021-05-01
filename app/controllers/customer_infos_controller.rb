class CustomerInfosController < ApplicationController
  before_action :set_customer_info, only: [:show, :update, :destroy]

  # 住所・電話番号・有料会員などの情報
  def return_customer_all_info
    # TODO::お客様の予約残り数は今月のもの。
    customer = Customer.find(params[:id])
    # customer = Customer.left_joins(:customer_info).select("*")
    t = Date.today
    this_month_first = DateTime.new(t.year, t.month, 1)
    customer_status = customer.customer_status
    # 今月のすでに予約したカウント数
    session_count = customer.appointments.where(finish: true).where("appointments.appointment_time >= ?", this_month_first).count
    appointment_count = customer.appointments.where(finish: false).where("appointments.appointment_time >= ?", this_month_first).count
    customer_info = customer.customer_info
    render json: {
      customer: customer,
      customer_status: customer_status,
      customer_info: customer_info,
      session_count: session_count,
      appointment_count: appointment_count
    }
  end
  # GET /customer_infos
  def index
    @customer_infos = CustomerInfo.all

    render json: @customer_infos
  end

  # GET /customer_infos/1
  def show
    render json: @customer_info
  end

  # POST /customer_infos
  def create
    if v1_customer_signed_in? 
      if @customer_info.save
        render json: @customer_info, status: 200, location: @customer_info
      else
        render json: @customer_info.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /customer_infos/1
  def update_avatar
    if current_v1_customer.id == params[:id].to_i
      customer_info = current_v1_customer.customer_info
      # 既存の画像を削除
      if customer_info.avatar.attached?
        customer_info.avatar.purge
      end
      customer_info.avatar.attach(params[:avatar])
      customer_info.avatar_url = customer_info.avatar.attachment.service.send(:object_for, customer_info.avatar.key).public_url
      
      interests = current_v1_customer.interests
      if customer_info.save
        render json: {
          message: "プロフィール画像を変更しました！", 
          status: 200, 
          data: customer_info,
          interests: interests
        }
      end
    else
      render json: {
        errors: "認証失敗です:ログインしてください", 
        status: 401
      }
    end
  end

  def update_all
    if v1_customer_signed_in? 
      @customer_info = current_v1_customer.customer_info
      @customer_info.age = (Date.today - params["birthday"].to_date).to_i/365
      @customer_info.birthday = params["birthday"].to_date
      @customer_info.postal_code = params["address"]["postalCode"]
      @customer_info.address = params["address"]["address"]
      @customer_info.gender  = params["gender"]
      @customer_info.phone_number = params["phoneNumber"]["nomal"]
      @customer_info.emergency_phone_number = params["phoneNumber"]["emergency"]
      @customer_info.customer_id = current_v1_customer.id
      interests = current_v1_customer.interests
      if @customer_info.save
        # render json: @customer_info, status: 200, location: @customer_info
        # render json: @customer_info, status: 200
        render json: {
          message: "基本情報を更新しました。", 
          status: 200, 
          data: @customer_info,
          interests: interests
        }
      else
        render json: @customer_info.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /customer_infos/1
  def destroy
    @customer_info.destroy
  end

  def check_jobs_show
      @jobs = Job.all
      render json: {
        jobs: @jobs,
        status: 200
      }
  end

  def check_jobs
  end

  def check_intarests_show
    @intarests = Interest.all
    render json: {
      intarests: @intarests,
      status: 200
    }
  end

  def check_intarests
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_info
      @customer_info = CustomerInfo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customer_info_params
      params.require(:customer_info).permit(:customer_id, :age, :birthday, :postal_code,  :address, :gender, :phone_number, :emergency_phone_number, :avatar, :avatar_url)
    end
end
