class CalendarController < ApplicationController
  
  def index
    if customer_signed_in? 
      customer = current_customer
    else
      customer = Customer.find(params[:customer_id])
    end
    if !params["customer_menu_id"].nil?
      @customer_menu_id = params["customer_menu_id"].to_i
    else
      @customer_menu_id = params["fitness"]["customer_menu_id"].to_i
    end
    if !params["store_id"].nil?
      @store_id = params["store_id"].to_i
    else
      @store_id = params["store"]["store_id"].to_i
    end
    @year = ((params[:year]).to_i)
    @month = ((params[:month]).to_i)
    @wday = Date.new((params[:year]).to_i,(params[:month]).to_i,1).wday
    @apos = Appointment.all
    @days_of_the_week = ["日","月","火","水","木","金","土"]
    @days_of_month = calendar_array((params[:year]).to_i%4)
    num = ((params[:month]).to_i) -1
    pre_num = num - 1
    if pre_num == -1
      pre_num = 11
    end
    @apo_num = customer_appointment_num_check(@year, @month, customer) # この月に予約した件数
    @days = @days_of_month[num]
    @pre_days = @days_of_month[pre_num]
  end

  # get '/calendar', to: 'calendar#select_store_fitness', as: 'calendar'
  def select_store_fitness
    # company_id を受け取って、store fitnessの情報を返す
    if v1_customer_signed_in?
      company_id = current_v1_customer.company_id
      @stores = Store.where(company_id: company_id)
      @fitness = Fitness.where(company_id: company_id)
      # response = {store: @stores, fitness: @fitness, year: Date.today.year, month: Date.today.month}
      render :json => {
        :store => @stores, 
        :fitnesses => @fitness,
        :year => Date.today.year,
        :month => Date.today.month
      }
    else
      render :json => {
        :message => "ログインしてください、認証が失敗しています"
      }
    end
  end

  def customer_appointment_num_check(year, month, customer) #特定のお客さんがある月に予約した件数
    from = Date.new(year , month, 1)
    to = Date.new(year , month, -1)
    this_month = Appointment.where(customer_id: customer.id).where("appointment_time >= ? AND appointment_time <= ?", from, to)
    this_month_num = this_month.count
    if !customer.customer_status.nil?
      customer_apos_max_num = customer.customer_status.numbers_of_contractnt
      return customer_apos_max_num - this_month_num
    else
      customer_apos_max_num = 0
      remaining = 0
      return 0
    end

  end

  def calendar_array(ok)
    if ok == 0
      a =  [
        [1,31],[1,29],[1,31],
        [1,30],[1,31],[1,30],
        [1,31],[1,31],[1,30],
        [1,31],[1,30],[1,31]
      ]
    else
      a =  [
        [1,31],[1,28],[1,31],
        [1,30],[1,31],[1,30],
        [1,31],[1,31],[1,30],
        [1,31],[1,30],[1,31]
      ]
    end
    return a
  end

  def find_company_id
    if v1_admin_signed_in?
      company_id = current_v1_admin.company_id
    elsif v1_trainer_signed_in?
      company_id = current_v1_trainer.company_id
    elsif v1_customer_signed_in?
      company_id = current_v1_customer.company_id
    end
    return company_id
  end

end
