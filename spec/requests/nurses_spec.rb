require 'rails_helper'

RSpec.describe "Nurses", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/nurses"
      expect(response).to have_http_status(:success)
    end
  end
end
