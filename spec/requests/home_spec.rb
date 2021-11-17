require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/home/index"
      expect(response).to have_http_status(:success)
    end
    it 'should clear the search_term from the session' do
      get "/home/index"
      expect(session[:search_term]).to be_nil
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get "/home/about"
      expect(response).to have_http_status(:success)
    end
    it 'should clear the search_term from the session' do
      get "/home/about"
      expect(session[:search_term]).to be_nil
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get "/home/contact"
      expect(response).to have_http_status(:success)
    end
    it 'should clear the search_term from the session' do
      get "/home/contact"
      expect(session[:search_term]).to be_nil
    end
  end
  describe "GET /medications" do
    it "returns http success" do
      get "/home/medications"
      expect(response).to have_http_status(:success)
    end
  end
  describe "POST /send_contact_message" do
    it "returns http redirect" do
      post "/home/send_contact_message", message: {:name => "Test Name", :email => "mail@test.com", :subject => "TEST", :message => "This is a message?"}
      expect(response).to have_http_status(302)
    end
  end
end
