class HomeController < ApplicationController
  def index
  end

  def about
  end

  def medications
  end

  def contact
  end

  def send_contact_message
    puts "Activated"
    @message = params[:message]
    @name = @message[:name]
    @email = @message[:email]
    @subject = @message[:subject]
    @message = @message[:message]
    ContactEmail.send_message(@name, @email, @subject, @message).deliver_later
    flash[:message] = "Message successfully sent"
    redirect_to home_contact_path
  end
end
