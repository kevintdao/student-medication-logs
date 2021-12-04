require 'spec_helper'
require 'rails_helper'

describe User do
  describe 'send password' do
    before :all do
      @user = User.where(:email => 'studenta@gmail.com')[0]
      @user.password = '123456'
      @user.password_confirmation = '123456'
      @user.save!
    end
    it 'should call generate token function' do
      expect(@user).to receive(:generate_token)
      @user.send_password_set
    end
    it 'should save new password_set_token and password_set_sent_at to the database' do
      old_password_set_token = User.where(:email => 'studenta@gmail.com')[0].password_set_token
      old_password_set_sent_at = User.where(:email => 'studenta@gmail.com')[0].password_set_sent_at
      @user.send_password_set
      new_password_set_token = User.where(:email => 'studenta@gmail.com')[0].password_set_token
      new_password_set_sent_at = User.where(:email => 'studenta@gmail.com')[0].password_set_sent_at
      expect(new_password_set_token).not_to eq(old_password_set_token)
      expect(new_password_set_sent_at).not_to eq(old_password_set_sent_at)
    end
  end
  it 'should return all users when the search term is empty' do
    users = User.search_users('Name', '', '1', 'Admin')
    expect(users[0].first_name).to eq('Admin')
    expect(users[0].last_name).to eq('1')
    expect(users.count).to eq(7)
  end
  context 'search by name' do
    it 'should return users with the searched first name' do
      users = User.search_users('Name', 'Admin', '1', 'Admin')
      expect(users.count).to eq(1)
    end
    it 'should return users with the searched first and last name' do
      users = User.search_users('Name', 'Admin 1', '1', 'Admin')
      expect(users[0].first_name).to eq('Admin')
      expect(users[0].last_name).to eq('1')
      expect(users.count).to eq(1)
    end
    it 'should return nil when no users with searched name' do
      users = User.search_users('Name', 'Admin Bob', '1', 'Admin')
      expect(users.count).to eq(0)
    end
  end
  context 'search by role' do
    it 'should return users with the role name' do
      users = User.search_users('Role', 'Nurse', '1', 'Admin')
      expect(users.count).to eq(1)
    end
    it 'should return nil when no users with the role name' do
      users = User.search_users('Role', 'Coordinator', '1', 'Admin')
      expect(users.count).to eq(0)
    end
  end
end
