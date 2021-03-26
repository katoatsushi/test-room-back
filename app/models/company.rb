class Company < ApplicationRecord
    # belongs_to :master_admin
    has_many :stores
    has_many :fitness
    # 各ユーザー
    has_many :customers
    has_many :trainers
    has_many :admins
    has_many :customer_menues
end
