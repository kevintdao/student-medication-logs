class HomeController < ApplicationController
  def index
  end

  def about
  end

  def medications
  end

  def contact
    @message = params[:message]
    ContactEmail.with(user: @message).send_message
    flash[:message] = "Message successfully sent"

  end
end
