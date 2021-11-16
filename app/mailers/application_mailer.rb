class ApplicationMailer < ActionMailer::Base
  default from: "contact.sml.team@gmail.com"
  layout 'mailer'

  def set_password(user)
    @user = user
    @greeting = 'Hi'
    mail to: user.email, :subject => 'Set Password Instructions'
  end
end
