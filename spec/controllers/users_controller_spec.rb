require 'spec_helper'
require 'rails_helper'

describe UsersController do
  describe 'register school district and administrator' do
    it 'should redirect to the login page' do
      fake_results = double('District')
      fake_id = double('Int')
      allow(District).to receive(:create_district).and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      post :register_district_admin, {:register => {:district_name => 'New Lake Schools',
                                                    :address1 => '1234 1st Avenue',
                                                    :city => 'Lakewood',
                                                    :state => 'IA',
                                                    :zipcode => '52253',
                                                    :first_name => 'Betsy',
                                                    :last_name => 'Smith',
                                                    :email => 'b.smith@outlook.com',
                                                    :password => 'hellothere',
                                                    :password_confirmation => 'hellothere'}}

      expect(flash[:message]).to be_present
      expect(flash[:message]).to eq('Successfully registered your account.')
      expect(response).to redirect_to(users_login_path)
    end
  end
end