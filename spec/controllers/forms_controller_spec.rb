require 'rails_helper'
require 'spec_helper'

describe FormsController do
  describe "GET /index" do
    it "renders the proper template" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      get :index
      expect(response).to redirect_to(forms_path)
    end
  end
end
