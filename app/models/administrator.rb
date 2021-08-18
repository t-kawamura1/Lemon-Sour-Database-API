# frozen_string_literal: true

class Administrator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :timeoutable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true, uniqueness: true
end
