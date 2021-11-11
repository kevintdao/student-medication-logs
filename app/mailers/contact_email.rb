class ContactEmail < ApplicationMailer
  default from: 'contact.sml.team@gmail.com'
  def send_message(name, email, subject, body)
    @name = name
    @email = email
    @subject = subject
    @body = body
    mail(to: "contact.sml.team@gmail.com", subject: @subject)
  end
end
