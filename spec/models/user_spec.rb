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
end

