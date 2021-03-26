# frozen_string_literal: true
class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User
  has_many :appointments
  has_one :customer_status
  has_one :customer_info
  has_many :customer_interests
  has_many :interests, through: :customer_interests
  # has_one_attached :avatar
end