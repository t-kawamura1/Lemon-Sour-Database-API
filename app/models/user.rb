# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :drinking_records, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :trackable, :validatable, :recoverable
  include DeviseTokenAuth::Concerns::User

  # ユーザー名以外はdevise-token-authのバリデーションを利用する。
  validates :name, presence: true, uniqueness: true
end
