require 'spec_helper'
require 'rails_helper'

describe AdminsController do
  describe 'associate student and parent' do
    before :all do
      @admin = User.where(email: 'admin1@gmail.com').first
    end
    it 'should correctly associate student and parent' do
      login(@admin)
      post :associatestudentparent, student: "1", parent: "2"
      expect(response).to redirect_to(admins_associate_page_path)
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq('Student and Parent successfully associated')
    end
    it 'should indicate when student and parent are already associated' do
      login(@admin)
      post :associatestudentparent, student: "1", parent: "1"
      expect(response).to redirect_to(admins_associate_page_path)
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq('Student and Parent are already associated')
    end
    it 'show students and parents correctly' do
      login(@admin)
      get :associate
      expect(response).to have_http_status(:ok)
    end
  end
end