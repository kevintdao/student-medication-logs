require 'spec_helper'
require 'rails_helper'

describe NursesController do
  describe "GET /index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end