require 'spec_helper'
require 'rails_helper'

describe NursesController do
  describe "GET /index" do
    it "returns http success" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end