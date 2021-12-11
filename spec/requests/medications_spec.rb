require 'rails_helper'

RSpec.describe "Medications", type: :request do
  describe "GET /index" do
    it "properly reads the session" do
      allow_any_instance_of(MedicationsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get medications_path
      expect(response).to have_http_status(:success)
      expect(assigns(:pages)).to eq(25)
      expect(assigns(:selection)).to eq("Ibuprofen")
    end
    it "loads when pages and the search term are nil" do
      get medications_path
      expect(response).to have_http_status(:success)
      expect(assigns(:medications)).not_to eq(nil)
    end
    it "loads when pages and the search term are not nil" do
      allow_any_instance_of(MedicationsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get medications_path
      expect(response).to have_http_status(:success)
      expect(assigns(:medications)).not_to eq(nil)
    end
    it "loads when pages are nil and search term is not" do
      allow_any_instance_of(MedicationsController).to receive(:session) {{"search_term": "Ibuprofen"}}
      get medications_path
      expect(response).to have_http_status(:success)
      expect(assigns(:medications)).not_to eq(nil)
    end
    it "loads when pages are not nil and search term is" do
      allow_any_instance_of(MedicationsController).to receive(:session) {{"page_count": 25}}
      get medications_path
      expect(response).to have_http_status(:success)
      expect(assigns(:medications)).not_to eq(nil)
    end
  end
  describe "POST /set_page_count" do
    it "redirects to medications path" do
      post medications_set_page_count_path
      expect(response).to redirect_to(medications_path)
    end
    it "sets the pages from the params" do
      post medications_set_page_count_path, page_count: {page_count: 25}
      expect(assigns(:pages)).to eq("25")
      expect(response).to redirect_to(medications_path)
    end
    it "sets the session correctly" do
      post medications_set_page_count_path, page_count: {page_count: 25}
      expect(session[:page_count]).to eq(25)
      expect(response).to redirect_to(medications_path)
    end
  end
  # describe "POST /search_events" do
  #   it "redirects to events_path" do
  #     post events_search_events_path
  #     expect(response).to redirect_to(events_path)
  #   end
  #   it "sets the session correctly" do
  #     post events_search_events_path, search_term: {search_term: "FName"}
  #     expect(session[:search_term]).to eq("FName")
  #     expect(response).to redirect_to(events_path)
  #   end
  # end
  describe "POST /search_meds" do
    it "redirects to medications_path" do
      post medications_search_meds_path
      expect(response).to redirect_to(medications_path)
    end
    it "sets the session correctly" do
      post medications_search_meds_path, search_term: {search_term: "Ibuprofen"}
      expect(session[:search_term]).to eq("Ibuprofen")
      expect(response).to redirect_to(medications_path)
    end
  end
end
