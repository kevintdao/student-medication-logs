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
    puts @message[:name]
    puts @message[:email]
    puts @message[:subject]
    puts @message[:message]
    #@message = params[:message]
    #ContactEmail.send_message(@message).deliver_now
    #flash[:message] = "Message successfully sent"
    redirect_to home_contact_path
  end
end
