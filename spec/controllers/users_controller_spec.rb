require 'spec_helper'
require 'rails_helper'

describe UsersController do
  describe 'register school district and administrator' do
    before :all do
      @register_params = {:register => {:district_name => 'New Lake Schools',
                                       :address1 => '1234 1st Avenue',
                                       :city => 'Lakewood',
                                       :state => 'IA',
                                       :zipcode => '52253',
                                       :first_name => 'Betsy',
                                       :last_name => 'Smith',
                                       :email => 'b.smith@outlook.com',
                                       :password => 'hellothere',
                                       :password_confirmation => 'hellothere'}}
    end
    it 'should redirect to the login page' do
      fake_results = double('District')
      fake_id = double('Int')
      allow(District).to receive(:create_district).and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      post :register_district_admin, @register_params
      expect(flash[:message]).to be_present
      expect(flash[:message]).to eq('Successfully registered your account.')
      expect(response).to redirect_to(users_login_path)
    end
    it 'should add a admin user to the database' do
      pre_user_entries_length = User.all.length
      pre_admin_entries_length = Admin.all.length
      fake_results = double('District')
      fake_id = double('Int')
      allow(District).to receive(:create_district).and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      post :register_district_admin, @register_params
      post_user_entries_length = User.all.length
      post_admin_entries_length = Admin.all.length
      expect(post_user_entries_length).to eq(pre_user_entries_length + 1)
      expect(post_admin_entries_length).to eq(pre_admin_entries_length + 1)
    end
    it 'should call the District model method to create a school district' do
      fake_results = double('District')
      fake_id = double('Int')
      expect(District).to receive(:create_district).with('New Lake Schools', '1234 1st Avenue', nil, 'Lakewood', 'IA', '52253').and_return(fake_results)
      expect(fake_results).to receive(:id).and_return(fake_id)
      post :register_district_admin, @register_params
    end
    it 'should validate that first name is present and not redirect to login page' do
      fake_results = double('District')
      fake_id = double('Int')
      allow(District).to receive(:create_district).with('New Lake Schools', '1234 1st Avenue', nil, 'Lakewood', 'IA', '52253').and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      no_first_name = @register_params.deep_dup
      no_first_name[:register][:first_name] = ' '
      post :register_district_admin, no_first_name
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq("First name can't be blank")
      expect(response).not_to redirect_to(users_login_path)
    end
    it 'should validate that last name is present and not redirect to login page' do
      fake_results = double('District')
      fake_id = double('Int')
      allow(District).to receive(:create_district).with('New Lake Schools', '1234 1st Avenue', nil, 'Lakewood', 'IA', '52253').and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      no_last_name = @register_params.deep_dup
      no_last_name[:register][:last_name] = ' '
      post :register_district_admin, no_last_name
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq("Last name can't be blank")
      expect(response).not_to redirect_to(users_login_path)
    end
    it 'should validate that email is present and not redirect to login page' do
      fake_results = double('District')
      fake_id = double('Int')
      allow(District).to receive(:create_district).with('New Lake Schools', '1234 1st Avenue', nil, 'Lakewood', 'IA', '52253').and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      no_email = @register_params.deep_dup
      no_email[:register][:email] = ' '
      post :register_district_admin, no_email
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq("Email can't be blank")
      expect(response).not_to redirect_to(users_login_path)
    end
    it 'should validate that password matches password confirmation' do
      fake_results = double('District')
      fake_id = double('Int')
      allow(District).to receive(:create_district).with('New Lake Schools', '1234 1st Avenue', nil, 'Lakewood', 'IA', '52253').and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      new_password_confirmation = @register_params.deep_dup
      new_password_confirmation[:register][:password_confirmation] = 'notoriginal'
      post :register_district_admin, new_password_confirmation
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq("Password confirmation doesn't match Password")
      expect(response).not_to redirect_to(users_login_path)
    end
    it 'should only accept unique email addresses' do
      fake_results = double('District')
      fake_id = double('Int')
      allow(District).to receive(:create_district).with('New Lake Schools', '1234 1st Avenue', nil, 'Lakewood', 'IA', '52253').and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      post :register_district_admin, @register_params
      post :register_district_admin, @register_params
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq("Email has already been taken")
      expect(response).not_to redirect_to(users_login_path)
    end
  end
end