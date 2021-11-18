require 'spec_helper'
require 'rails_helper'

describe User do
  fixtures :users
  it 'should return all users when the search term is empty' do
    users = User.search_users('Name', '')
    expect(users[0].first_name).to eq('Admin')
    expect(users[0].last_name).to eq('Apple')
    expect(users.count).to eq(4)
  end
  context 'search by name' do
    it 'should return users with the searched first name' do
      users = User.search_users('Name', 'Admin')
      expect(users.count).to eq(2)
    end
    it 'should return users with the searched first and last name' do
      users = User.search_users('Name', 'Admin Apple')
      expect(users[0].first_name).to eq('Admin')
      expect(users[0].last_name).to eq('Apple')
      expect(users.count).to eq(1)
    end
    it 'should return nil when no users with searched name' do
      users = User.search_users('Name', 'Admin Bob')
      expect(users.count).to eq(0)
    end
  end
  context 'search by role' do
    it 'should return users with the role name' do
      users = User.search_users('Role', 'Nurse')
      expect(users.count).to eq(2)
    end
    it 'should return nil when no users with the role name' do
      users = User.search_users('Role', 'Coordinator')
      expect(users.count).to eq(0)
    end
  end
end