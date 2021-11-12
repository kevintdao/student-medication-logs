class HomeController < ApplicationController
  def index
    session[:search_term] = nil
  end

  def about
    session[:search_term] = nil
  end

  def medications
  end

  def contact
    session[:search_term] = nil
  end

  def send_contact_message
    @message = params[:message]
    @name = @message[:name]
    @email = @message[:email]
    @subject = @message[:subject]
    @message = @message[:message]
    ContactEmail.send_message(@name, @email, @subject, @message).deliver_later
    flash[:notice] = "Message successfully sent"
    redirect_to home_contact_path
  end
end
