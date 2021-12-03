require 'rails_helper'
require 'spec_helper'

describe InventoriesController do
  describe "GET /index" do
    it "renders the proper template if logged in" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      get :index
      expect(response).not_to redirect_to(home_index_path)
    end

    it "redirects to the homepage if not logged in" do
      get :index
      expect(response).to redirect_to(home_index_path)
    end
  end
end

