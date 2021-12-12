class ApplicationMailer < ActionMailer::Base
  default from: "StudentMedLog@sml-team02.com"
  layout 'mailer'

  def set_password(user)
    @user = user
    @greeting = 'Hi'
    mail to: user.email, :subject => 'Set Password For SML'
  end
end
