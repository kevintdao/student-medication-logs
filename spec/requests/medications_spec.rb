require 'rails_helper'

RSpec.describe "Medications", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/home/medications"
      expect(response).to have_http_status(:success)
    end
  end
end
