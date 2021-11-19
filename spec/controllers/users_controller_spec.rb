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
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("First name can't be blank")
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
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Last name can't be blank")
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
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Email can't be blank")
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
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Password confirmation doesn't match Password")
      expect(response).not_to redirect_to(users_login_path)
    end
    it 'should only accept unique email addresses' do
      fake_results = double('District')
      fake_id = double('Int')
      allow(District).to receive(:create_district).with('New Lake Schools', '1234 1st Avenue', nil, 'Lakewood', 'IA', '52253').and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      post :register_district_admin, @register_params
      post :register_district_admin, @register_params
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Email has already been taken')
      expect(response).not_to redirect_to(users_login_path)
    end
  end
  describe 'admin creates user' do
    before :all do
      @new_user = {:new_user => {:user_type => 'Student',
                                 :first_name => 'Betsy',
                                 :last_name => 'Smith',
                                 :email => 'b.smith@outlook.com'}}
    end
    it 'should save Student to the Users table and Student table in database' do
      pre_users_length = User.all.length
      pre_students_length = Student.all.length
      allow(User).to receive(:send_password_set)
      new_student = @new_user.deep_dup
      new_student[:new_user][:user_type] = 'Student'
      post :create_and_email, new_student
      post_users_length = User.all.length
      post_students_length = Student.all.length
      expect(post_users_length).to eq(pre_users_length + 1)
      expect(post_students_length).to eq(pre_students_length + 1)
    end
    it 'should save Parent to the database' do
      pre_users_length = User.all.length
      pre_parents_length = Parent.all.length
      allow(User).to receive(:send_password_set)
      new_parent = @new_user.deep_dup
      new_parent[:new_user][:user_type] = 'Parent'
      post :create_and_email, new_parent
      post_users_length = User.all.length
      post_parents_length = Parent.all.length
      expect(post_users_length).to eq(pre_users_length + 1)
      expect(post_parents_length).to eq(pre_parents_length + 1)
    end
    it 'should save Nurse to the database' do
      pre_users_length = User.all.length
      pre_nurse_length = Nurse.all.length
      allow(User).to receive(:send_password_set)
      new_nurse = @new_user.deep_dup
      new_nurse[:new_user][:user_type] = 'Nurse'
      post :create_and_email, new_nurse
      post_users_length = User.all.length
      post_nurse_length = Nurse.all.length
      expect(post_users_length).to eq(pre_users_length + 1)
      expect(post_nurse_length).to eq(pre_nurse_length + 1)
    end
    it 'should save Admin to the database' do
      pre_users_length = User.all.length
      pre_admin_length = Admin.all.length
      allow(User).to receive(:send_password_set)
      new_admin = @new_user.deep_dup
      new_admin[:new_user][:user_type] = 'Admin'
      post :create_and_email, new_admin
      post_users_length = User.all.length
      post_admin_length = Admin.all.length
      expect(post_users_length).to eq(pre_users_length + 1)
      expect(post_admin_length).to eq(pre_admin_length + 1)
    end
    it 'should validate that first name is present' do
      allow(User).to receive(:send_password_set)
      no_first_name = @new_user.deep_dup
      no_first_name[:new_user][:first_name] = ' '
      post :create_and_email, no_first_name
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("First name can't be blank")
    end
    it 'should validate that last name is present' do
      allow(User).to receive(:send_password_set)
      no_last_name = @new_user.deep_dup
      no_last_name[:new_user][:last_name] = ' '
      post :create_and_email, no_last_name
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Last name can't be blank")
    end
    it 'should validate that email address is present' do
      allow(User).to receive(:send_password_set)
      no_email = @new_user.deep_dup
      no_email[:new_user][:email] = ' '
      post :create_and_email, no_email
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Email can't be blank")
    end
    it 'should only accept unique email addresses' do
      allow(User).to receive(:send_password_set)
      post :create_and_email, @new_user
      post :create_and_email, @new_user
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Email has already been taken')
    end
  end
  # describe 'user sets new password' do
  #
  # end
end