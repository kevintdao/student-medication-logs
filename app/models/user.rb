require 'bcrypt'

class User < ActiveRecord::Base
  has_secure_password
  before_save { |user| user.email = user.email.downcase }
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validates :password, confirmation: { case_sensitive: true }

  def send_password_set
    generate_token(:password_set_token)
    self.password_set_sent_at = Time.zone.now
    save!
    ApplicationMailer.set_password(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
