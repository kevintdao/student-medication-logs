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
    after :each do
      delete_user = User.where(:email => 'b.smith@outlook.com')[0]
      unless delete_user.nil?
        Admin.delete(delete_user.role_id)
        User.delete(delete_user.id)
      end
    end
    it 'should redirect to the login page' do
      fake_results = double('District')
      fake_id = 1
      allow(District).to receive(:create_district).and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      post :register_district_admin, @register_params
      expect(flash[:message]).to be_present
      expect(flash[:message]).to eq('Successfully registered your account.')
      expect(response).to redirect_to(login_path)
    end
    it 'should add a admin user to the database' do
      pre_user_entries_length = User.all.length
      pre_admin_entries_length = Admin.all.length
      fake_results = double('District')
      fake_id = 1
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
      fake_id = 1
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
      expect(response).not_to redirect_to(login_path)
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
      expect(response).not_to redirect_to(login_path)
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
      expect(response).not_to redirect_to(login_path)
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
      expect(response).not_to redirect_to(login_path)
    end
    it 'should only accept unique email addresses' do
      fake_results = double('District')
      fake_id = 1
      allow(District).to receive(:create_district).with('New Lake Schools', '1234 1st Avenue', nil, 'Lakewood', 'IA', '52253').and_return(fake_results)
      allow(fake_results).to receive(:id).and_return(fake_id)
      post :register_district_admin, @register_params
      post :register_district_admin, @register_params
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Email has already been taken')
      expect(response).not_to redirect_to(login_path)
    end
  end
  describe 'admin creates user' do
    before :all do
      @new_user = {:new_user => {:user_type => 'Student',
                                 :first_name => 'Betsy',
                                 :last_name => 'Smith',
                                 :email => 'b.smith@outlook.com'}}
    end
    after :each do
      delete_user = User.where(:email => 'b.smith@outlook.com')[0]
      unless delete_user.nil?
        case delete_user.role
        when 'Admin'
          Admin.delete(delete_user.role_id)
        when 'Student'
          Student.delete(delete_user.role_id)
        when 'Parent'
          Parent.delete(delete_user.role_id)
        when 'Nurse'
          Nurse.delete(delete_user.role_id)
        end
        User.delete(delete_user.id)
      end
    end
    it 'should save Student the database' do
      controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
      pre_users_length = User.all.length
      pre_students_length = Student.all.length
      allow(@new_user).to receive(:send_password_set)
      new_student = @new_user.deep_dup
      new_student[:new_user][:user_type] = 'Student'
      post :create_and_email, new_student
      post_users_length = User.all.length
      post_students_length = Student.all.length
      expect(post_users_length).to eq(pre_users_length + 1)
      expect(post_students_length).to eq(pre_students_length + 1)
    end
    it 'should save Parent to the database' do
      controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
      pre_users_length = User.all.length
      pre_parents_length = Parent.all.length
      allow(@new_user).to receive(:send_password_set)
      new_parent = @new_user.deep_dup
      new_parent[:new_user][:user_type] = 'Parent'
      post :create_and_email, new_parent
      post_users_length = User.all.length
      post_parents_length = Parent.all.length
      expect(post_users_length).to eq(pre_users_length + 1)
      expect(post_parents_length).to eq(pre_parents_length + 1)
    end
    it 'should save Nurse to the database' do
      controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
      pre_users_length = User.all.length
      pre_nurse_length = Nurse.all.length
      allow(@new_user).to receive(:send_password_set)
      new_nurse = @new_user.deep_dup
      new_nurse[:new_user][:user_type] = 'Nurse'
      post :create_and_email, new_nurse
      post_users_length = User.all.length
      post_nurse_length = Nurse.all.length
      expect(post_users_length).to eq(pre_users_length + 1)
      expect(post_nurse_length).to eq(pre_nurse_length + 1)
    end
    it 'should save Admin to the database' do
      controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
      pre_users_length = User.all.length
      pre_admin_length = Admin.all.length
      allow(@new_user).to receive(:send_password_set)
      new_admin = @new_user.deep_dup
      new_admin[:new_user][:user_type] = 'Admin'
      post :create_and_email, new_admin
      post_users_length = User.all.length
      post_admin_length = Admin.all.length
      expect(post_users_length).to eq(pre_users_length + 1)
      expect(post_admin_length).to eq(pre_admin_length + 1)
    end
    it 'should validate that first name is present' do
      allow(@new_user).to receive(:send_password_set)
      no_first_name = @new_user.deep_dup
      no_first_name[:new_user][:first_name] = ' '
      post :create_and_email, no_first_name
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("First name can't be blank")
    end
    it 'should validate that last name is present' do
      allow(@new_user).to receive(:send_password_set)
      no_last_name = @new_user.deep_dup
      no_last_name[:new_user][:last_name] = ' '
      post :create_and_email, no_last_name
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Last name can't be blank")
    end
    it 'should validate that email address is present' do
      controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
      allow(@new_user).to receive(:send_password_set)
      no_email = @new_user.deep_dup
      no_email[:new_user][:email] = ' '
      post :create_and_email, no_email
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Email can't be blank")
    end
    it 'should only accept unique email addresses' do
      controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
      allow(@new_user).to receive(:send_password_set)
      post :create_and_email, @new_user
      post :create_and_email, @new_user
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Email has already been taken')
    end
  end
  describe 'user sets new password' do
    before :all do
      @user = User.where(:email => 'studenta@gmail.com')[0]
      @user.password = '123456'
      @user.password_confirmation = '123456'
      @user.password_set_token = SecureRandom.urlsafe_base64
      @user.password_set_sent_at = Time.zone.now
      @user.save!
      @new_password = {:new_pass => {:password => 'password1',
                                     :password_confirmation => 'password1' },
                       :format => @user.password_set_token }
    end
    after :each do
      delete_user = User.where(:email => 'b.smith@outlook.com')[0]
      unless delete_user.nil?
        User.delete(delete_user.id)
      end
    end
    it 'should save a new password to the database' do
      old_password = User.where(:email => 'studenta@gmail.com')[0].password_digest
      post :set_password, @new_password
      new_password = User.where(:email => 'studenta@gmail.com')[0].password_digest
      expect(new_password).not_to eq(old_password)
    end
    it 'should redirect to the login page' do
      post :set_password, @new_password
      expect(response).to redirect_to(login_path)
    end
    it 'should validate that a password is present' do
      no_password = @new_password.deep_dup
      no_password[:new_pass][:password] = ''
      post :set_password, no_password
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Password can't be blank")
      expect(response).not_to redirect_to(login_path)
    end
    it 'should validate that a password confirmation is present' do
      no_password_confirm = @new_password.deep_dup
      no_password_confirm[:new_pass][:password_confirmation] = ''
      post :set_password, no_password_confirm
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Password confirmation doesn't match Password")
      expect(response).not_to redirect_to(login_path)
    end
    it 'should validate that the password matches the password confirmation' do
      different_password_confirm = @new_password.deep_dup
      different_password_confirm[:new_pass][:password_confirmation] = 'wrongPassword1'
      post :set_password, different_password_confirm
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Password confirmation doesn't match Password")
      expect(response).not_to redirect_to(login_path)
    end
    it 'should validate that the set password token has expired after 2 days' do
      @user.password_set_sent_at = 2.days.ago
      @user.save!
      post :set_password, @new_password
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Password set has expired')
      expect(response).not_to redirect_to(login_path)
    end
  end

  describe 'display users' do
    context 'search users' do
      it 'should redirect to login page if not logged in' do
        get :index, {}
        expect(response).to redirect_to(login_path)
      end
      it 'should call the model method that search users' do
        controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
        user = double('admin1')
        expect(User).to receive(:search_users).with('Name', 'admin', 1, 'Admin').and_return(user)
        get :index, { search: { type: 'Name', term: 'admin' } }
      end
      it 'should return all users when search term is empty' do
        controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
        get :index, {}
        expect(response).to render_template('index')
      end
      it 'should flash error message if no users exists' do
<<<<<<< HEAD
        allow(User).to receive(:search_users).with('Name', 'asdf', 1, 'Admin').and_return(nil)
=======
        controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
        allow(User).to receive(:search_users).with('Name', 'asdf', 1).and_return(nil)
>>>>>>> main
        get :index, { search: { type: 'Name', term: 'asdf' } }
        expect(flash[:error]).to eq('No users found!')
        expect(response).to redirect_to(users_path)
      end
    end
  end
  describe 'get the event for student' do
    it 'should redirect to login page if not logged in' do
      get :show, id: 5
      expect(response).to redirect_to(login_path)
    end
    it 'should get the events for given student id' do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :show, id: 5
      expect(response).to render_template('show')
    end
  end

  describe 'only allow valid user to view profile' do
    context 'admin' do
      it 'should redirect to users page if user is not in district' do
        controller.instance_variable_set(:@current_user, User.where(email: 'admin1@gmail.com')[0])
        get :show, id: 11
        expect(response).to redirect_to(users_path)
      end
    end
    context 'nurse' do
      it 'should redirect to users page if user is not in district' do
        controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
        get :show, id: 11
        expect(response).to redirect_to(users_path)
      end
      it 'should redirect to users page if user role is not valid for current user' do
        controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
        get :show, id: 1
        expect(response).to redirect_to(users_path)
      end
    end
    context 'parent' do
      it 'should redirect to dashboard if user is not in district' do
        controller.instance_variable_set(:@current_user, User.where(email: 'parent1a@gmail.com')[0])
        get :show, id: 11
        expect(response).to redirect_to(parents_path)
      end
      it 'should redirect to dashboard if user role is not valid for current user' do
        controller.instance_variable_set(:@current_user, User.where(email: 'parent1a@gmail.com')[0])
        get :show, id: 1
        expect(response).to redirect_to(parents_path)
      end
    end
    context 'student' do
      it 'should redirect to dashboard if user is not in district' do
        controller.instance_variable_set(:@current_user, User.where(email: 'studenta@gmail.com')[0])
        get :show, id: 11
        expect(response).to redirect_to(students_path)
      end
      it 'should redirect to dashboard if user role is not valid for current user' do
        controller.instance_variable_set(:@current_user, User.where(email: 'studenta@gmail.com')[0])
        get :show, id: 1
        expect(response).to redirect_to(students_path)
      end
    end
  end
end