# frozen_string_literal: true

class Trainer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_one :trainer
  has_many :trainer_shifts
  has_many :trainer_fitnesses
  has_one  :trainer_info
  has_many :fitnesses, through: :trainer_fitnesses
end
