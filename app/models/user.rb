require 'bcrypt'

class User < ActiveRecord::Base
  has_secure_password
  before_save { |user| user.email = user.email.downcase }
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  # , format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validates :password, confirmation: { case_sensitive: true }
end
