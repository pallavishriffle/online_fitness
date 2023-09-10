# frozen_string_literal: true

class User < ApplicationRecord
  has_many :programs, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_one_attached :avatar

  has_secure_password

  validates :name, :email, :mobile, :type, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password_digest, length: { minimum: 8 }, format: { with: /\A\S+\z/ }
  validates :mobile, length: { is: 10 }, uniqueness: true
end
