require 'rails_helper'

RSpec.describe "PasswordSets", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/password_sets/new"
      expect(response).to have_http_status(:success)
    end
  end

end
