class User < ActiveRecord::Base
  has_secure_password
  before_save { |user| user.email = user.email.downcase }
  before_save :create_session_token
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :role, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validates :password, confirmation: { case_sensitive: true }

  def self.search_users(type, term, district_id, role)
    return User.where(district_id: district_id) if term.blank? && role == 'Admin'
    return User.where(district_id: district_id, role: %w[Student Parent]) if term.blank? && role == 'Nurse'

    case role
    when 'Admin'
      if type == 'Name'
        User.search_name(term.split, district_id, role)
      else
        User.where('lower(role) = ? and district_id = ?', term.downcase, district_id)
      end
    else
      User.search_name(term.split, district_id, role)
    end
  end

  def send_password_set
    generate_token(:password_set_token)
    self.password_set_sent_at = Time.zone.now
    save!
    ApplicationMailer.set_password(self).deliver
  end

  private

  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end

  def self.search_name(name, district_id, role)
    if role == 'Admin'
      if name.count == 1
        User.where('lower(first_name) = ? and district_id = ?', name[0].downcase, district_id)
      else
        User.where('lower(first_name) = ? and lower(last_name) = ? and district_id = ?', name[0].downcase, name[1].downcase,district_id)
      end
    else
      if name.count == 1
        User.where('lower(first_name) = ? and district_id = ? and lower(role) IN (?)', name[0].downcase, district_id, %w[student parent])
      else
        User.where('lower(first_name) = ? and lower(last_name) = ? and district_id = ? and lower(role) IN (?)', name[0].downcase, name[1].downcase,district_id, %w[student parent])
      end
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
