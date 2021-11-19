require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/events"
      expect(response).to have_http_status(:success)
    end
    it "properly reads the session" do
      # TODO - How to pass session information to index
      get(events_path, nil, { "page_count": 25, "search_term": "Ibuprofen"})
      expect(response).to have_http_status(:success)
      expect(assigns(:pages)).to eq(25)
      expect(assigns(:selection)).to eq("Ibuprofen")
    end
  end
end