class CustomerInfo < ApplicationRecord
    belongs_to :customer
    # belongs_to :job
    has_one_attached :avatar
    # def avatar_url
    #     # 紐づいている画像のURLを取得する
    #     avatar.attached? ? url_for(avatar) : nil
    # end
end
