class ContactEmail < ApplicationMailer
  default from: 'contact.sml.team@gmail.com'
  def send_message(message)
    @message = message
    mail(to: "contact.sml.team@gmail.com", subject: "Test")
  end
end
