# Preview all emails at http://localhost:3000/rails/mailers/contact_email
class ContactEmailPreview < ActionMailer::Preview
  def send_message
    # Set up a temporary order for the preview
    @name = "Test"
    @email = "testmail@mail.com"
    @subject = "My Subject"
    @message = "This is a question"
    ContactEmail.send_message(@name, @email, @subject, @message)
  end
end
