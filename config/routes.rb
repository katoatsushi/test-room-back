Rails.application.routes.draw do
  root 'home#index'
  resources :black_schedules
  resources :trainer_infos
  resources :evaluations
  resources :customer_record_session_menus
  resources :customer_records
  # # トレーナーのシフト作成
  # post '/trainer/shift/create/year/:year/month/:month', to: 'trainer_shifts#create', as: 'trainer_shifts_create'
  # トレーナーのシフト更新
  put '/trainer/shift/create/year/:year/month/:month', to: 'trainer_shifts#update', as: 'trainer_shifts_update'

  put '/customer/update_avatar/:id', to: 'customer_infos#update_avatar', as: 'update_customer_avatar'
  get '/return_customer_all_info/:id', to: 'customer_infos#return_customer_all_info', as: 'return_customer_all_info'
  put '/customer_infos', to: 'customer_infos#update_all', as: 'customer_update_all'

  put '/customer_individual_infos', to: 'customer_individual_info#update_all', as: 'update_customer_ndividual_info'
  put '/customer_update_interests', to: 'customer#update_interests', as: 'customer_update_interests'

  get '/customer_statuses/:customer_id', to: 'customer_statuses#show', as: 'get_customer_status'
  post '/customer_statuses/:customer_id', to: 'customer_statuses#create', as: 'create_customer_status'
  # 会員情報を更新
  put  '/customer_statuses/:id', to: 'customer_statuses#update', as: 'update_customer_status'
  get '/after_customer_sign_in', to: 'customer#return_customers', as: 'after_customer_sign_in'
  # 全顧客情報を取得
  get '/admin/get/all_customers',to: 'admin_management#all_customer', as: 'admin_all_customer'
  get '/trainer/get/all_customers',to: 'trainer_management#all_customer', as: 'trainer_all_customer'
  
  # トレーナーの自身の評価
  get '/trainer/get/my_evaluation/:id',to: 'trainer_management#my_evaluation', as: 'trainer_my_evaluation'
  
  get '/serch/customers',to: 'admin_management#search_customer', as: 'search_customer'
  #  トレーナーのシフトを送る
  get '/get_trainer_shifts',to: 'admin_management#get_trainer_shifts', as: 'get_trainer_shifts'
  # トレーナーのシフトを更新する
  put '/update_trainer_shift',to: 'admin_management#update_trainer_shift', as: 'update_trainer_shift'
  # 全てのトレーナーを取得
  get '/admin/get/trainer_all', to: 'admin_management#all_trainer', as: 'admin_management_all_trainer'
  get '/check_evaluation/:customer_id', to: 'admin_management#check_evaluation', as: 'check_evaluation'
  # トレーナーのプロフィール画像を変更
  put '/trainer/update_avatar', to: 'trainer_infos#update_avatar', as: 'trainer_update_avatar'
  # お客様のセッションカルテを返す
  get '/trainer/get/customer_records', to: 'trainer_management#get_customer_records', as: 'get_customer_records'
  # 発行済みのレコードの確認
  get '/show/record/:id', to: 'trainer_management#check_finished_record', as: 'check_finished_record'
  # 発行済みのレコードの削除
  delete '/delete/record/:appointment_id', to: 'trainer_management#record_delete', as: 'record_delete'
  # 店舗を有効化から外す
  put '/admin/store/deactivate/:id', to: 'stores#deactivate', as: 'store_deactivate'
  # トレーナーの自信が提出した希望シフト
  get '/trainer/shifts/my_requested_shift/year/:year/month/:month', to: 'trainer_management#my_requested_shift', as: 'my_requested_shift'
  
  resources :customer_weights
  # ログイン・パスワード
  namespace :v1 do
    # マスタアカウント
    mount_devise_token_auth_for "MasterAdmin", at: "master_admin_auth", controllers: {
      passwords: 'v1/auth/master_admins/passwords',
      sessions: 'v1/auth/master_admins/sessions'
    }
    # お客様
    mount_devise_token_auth_for "Customer", at: "customer_auth", controllers: {
      passwords: 'v1/auth/customers/passwords',
      sessions: 'v1/auth/customers/sessions',
    }
      # 管理者
      mount_devise_token_auth_for 'Admin', at: 'admin_auth', controllers: {
        passwords: 'v1/auth/admins/passwords',
        sessions: 'v1/auth/admins/sessions'
      }
      # トレーナー
      mount_devise_token_auth_for 'Trainer', at: 'trainer_auth', controllers: {
        passwords: 'v1/auth/trainers/passwords',
        sessions: 'v1/auth/trainers/sessions'
      }
  end
  # 新規登録
  resources :companies do
    namespace :v1 do
      # お客様
      mount_devise_token_auth_for 'Customer', at: 'customer_auth', controllers: {
          registrations: 'v1/auth/customers/registrations'
      }
      # 管理者
      mount_devise_token_auth_for 'Admin', at: 'admin_auth', controllers: {
        registrations: 'v1/auth/admins/registrations'
      }
      # トレーナー
      mount_devise_token_auth_for 'Trainer', at: 'trainer_auth', controllers: {
        registrations: 'v1/auth/trainers/registrations'
      }
    end
  end

  # お客様の認証メールの確認
  post 'customer_confirm_ok', to: 'customer_confirmations#check', as: 'confirm_check'
  # トレーナーのメニューの連携ずけ
  post '/set_fitnesses', to: 'trainer#set_fitnesses', as: 'set_fitnesses'
  # トレーナーの2階層目
  get '/get/res_second/fitness/:id', to: 'fitnesses#res_second', as: 'res_second'
  # トレーナーが自身のプロフィールの編集を行う
  put '/trainer/update/myself', to: 'trainer#update_profile', as: 'trainer_update_profile'

  resources :fitness_fourths
  resources :fitness_thirds
  resources :fitness_seconds
  resources :fitnesses
  resources :stores
  resources :companies
  # お客様の詳細ページ
  get '/customer_page/:id', to: 'customer_page#show', as: 'get_customer'
  get '/customer_page/my_past/records/:id', to: 'customer_page#my_past_records', as: 'get_customer_my_past_records'
  # 全お客様のページ
  get '/customer_page_all/:company_id', to: 'customer_page#index', as: 'get_all_customers'
  # お客様の職業選択
  get '/customer_info/jobs_new', to: 'customer_infos#check_jobs_show', as: 'check_jobs_show'
  post '/customer_info/jobs_create', to: 'customer_infos#check_jobs', as: 'check_jobs'
  # お客様の関心のある分野
  get '/customer_info/intarests_new', to: 'customer_infos#check_intarests_show', as: 'check_intarests_show'
  post '/customer_info/intarests_create', to: 'customer_infos#check_intarests', as: 'check_intarests'
  # ログインしているユーザー
  get '/customer_search', to: 'home#customer_search', as: 'customer_search'
  get '/admin_search', to: 'home#admin_search', as: 'admin_search'
  get '/trainer_search', to: 'home#trainer_search', as: 'trainer_search'
  get '/master_admin_search', to: 'home#master_admin_search', as: 'master_admin_search'

  get '/customer_feedback', to: 'customer_page#feedback_to_trainer', as: 'customer_feedback'
  get '/customer/after/sign_in', to: 'customer#after_login', as: 'customerafter_login'
  # カルテ発行
  post '/customer/:customer_id/appointment/:appointment_id/create_customer_record', to: 'customer_records#create', as: 'create_customer_record'
  # カルテ発行に伴う、Sessionの選択
  # ここあとで消す
  get '/customer_record/:customer_record_id/new', to: 'customer_record_session_menus#new', as: 'new_record_session_menus'
  post '/customer/:customer_record_id/fitness/:fitness_id/fitness_third/:fitness_third_id/session/create', to: 'customer_record_session_menus#create', as: 'create_record_session_menus'
  # ここまで
  # トレーナーのお客さんのカルテ発行
  post '/create/record/session_menues/appointment/:appointment_id', to: 'customer_record_session_menus#create_record_and_menues', as: 'create_record_and_menues'
  # お客さんは自分で予約を行う場合
  get '/calendar', to: 'calendar#select_store_fitness', as: 'calendar'
  
  get '/calendar/:store_id/:fitness_id/:year/:month', to: 'calendar#index', as: 'calendar_change'
  get '/appointments/new/:store_id/:fitness_id/:year/:month/:day', to: 'appointments#new', as: 'new_appointment'
  # 空き状況
  get '/appointments/vacancy/:company_id/:fitness_id/:year/:month/:day', to: 'appointments#vacancy', as: 'vacancy_appointment'
  post '/customer/:customer_id/appointments/new/:store_id/:fitness_id/:year/:month/:day', to: 'appointments#create', as: 'create_appointment'

  # 開発テスト用
  get '/customer/get_company_id', to: 'customer#get_company_id', as: 'customer_get_company_id'

  get '/appointments/:id/edit/:year/:month/:day', to: 'appointments#edit', as:  'edit_appointment'
  #  予約キャンセル
  delete '/appointment/:id', to: 'appointments#destroy', as:  'delete_appointment'
  
  # 管理者のページ
  get '/admin/company_id/:company_id/year/:year/month/:month/day/:day', to: 'home#today', as: 'admin_today'
  get '/admin/date_schedule/company_id/:company_id/year/:year/month/:month/day/:day', to: 'home#date_schedule', as: 'admin_date_schedule'
  
  # get '/admin/company_id/:company_id/year/:year/month/:month', to: 'home#oneday', as: 'admin_oneday'
end
