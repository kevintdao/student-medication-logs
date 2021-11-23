require 'rails_helper'
require 'spec_helper'

RSpec.describe "Events", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/events"
      expect(response).to have_http_status(:success)
    end
    it "properly reads the session" do
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:pages)).to eq(25)
      expect(assigns(:selection)).to eq("Ibuprofen")
    end
    it "loads when pages and the search term are nil" do
      get events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages and the search term are not nil" do
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages are nil and search term is not" do
      allow_any_instance_of(EventsController).to receive(:session) {{"search_term": "Ibuprofen"}}
      get events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages are not nil and search term is" do
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25}}
      get events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
  end
  describe "GET /past_events" do
    it "returns http success" do
      get events_past_events_path
      expect(response).to have_http_status(:success)
    end
    it "properly reads the session" do
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get events_past_events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:pages)).to eq(25)
      expect(assigns(:selection)).to eq("Ibuprofen")
    end
    it "loads when pages and the search term are nil" do
      get events_past_events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages and the search term are not nil" do
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get events_past_events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages are nil and search term is not" do
      allow_any_instance_of(EventsController).to receive(:session) {{"search_term": "Ibuprofen"}}
      get events_past_events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages are not nil and search term is" do
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25}}
      get events_past_events_path
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
  end
  describe "POST /set_page_count" do
    it "redirects to event path" do
      post events_set_page_count_path
      expect(response).to redirect_to(events_path)
    end
    it "sets the pages from the params" do
      post events_set_page_count_path, page_count: {page_count: 25}
      expect(assigns(:pages)).to eq("25")
      expect(response).to redirect_to(events_path)
    end
    it "sets the session correctly" do
      post events_set_page_count_path, page_count: {page_count: 25}
      expect(session[:page_count]).to eq(25)
      expect(response).to redirect_to(events_path)
    end
  end
  describe "POST /search_events" do
    it "redirects to events_path" do
      post events_search_events_path
      expect(response).to redirect_to(events_path)
    end
    it "sets the session correctly" do
      post events_search_events_path, search_term: {search_term: "FName"}
      expect(session[:search_term]).to eq("FName")
      expect(response).to redirect_to(events_path)
    end
  end
  describe "POST /set_past_page_count" do
    it "redirects to past events path" do
      post events_set_past_page_count_path
      expect(response).to redirect_to(events_past_events_path)
    end
    it "sets the pages from the params" do
      post events_set_past_page_count_path, page_count: {page_count: 25}
      expect(assigns(:pages)).to eq("25")
      expect(response).to redirect_to(events_past_events_path)
    end
    it "sets the session correctly" do
      post events_set_past_page_count_path, page_count: {page_count: 25}
      expect(session[:page_count]).to eq(25)
      expect(response).to redirect_to(events_past_events_path)
    end
  end
  describe "POST /search_past_events" do
    it "redirects to past_events_path" do
      post events_search_past_events_path
      expect(response).to redirect_to(events_past_events_path)
    end
    it "sets the session correctly" do
      post events_search_past_events_path, search_term: {search_term: "FName"}
      expect(session[:search_term]).to eq("FName")
      expect(response).to redirect_to(events_past_events_path)
    end
  end
end