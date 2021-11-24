class User < ActiveRecord::Base
  has_secure_password
  before_save { |user| user.email = user.email.downcase }
  before_save :create_session_token
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PHONE_REGEX = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/i
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :save
  validates :password_confirmation, presence: true, on: :save
  validates :password, confirmation: { case_sensitive: true }, on: :save
  validates :phone, allow_blank: true, allow_nil: true, format: { with: VALID_PHONE_REGEX }

  def self.search_users(type, term, district_id)
    return User.where(district_id: district_id) if term.blank?

    if type == 'Name'
      name = term.split
      if name.count == 1
        User.where('lower(first_name) = ? and district_id = ?', name[0].downcase, district_id)
      else
        User.where('lower(first_name) = ? and lower(last_name) = ? and district_id = ?', name[0].downcase, name[1].downcase,district_id)
      end
    else
      User.where('lower(role) = ? and district_id = ?', term.downcase, district_id)
    end
  end

  private

  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end
end
