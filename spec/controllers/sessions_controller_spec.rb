require 'spec_helper'
require 'rails_helper'

describe SessionsController do
  context "create a new login session" do
    it 'should redirect to the login page if the username is empty' do
      post :create, { email: { email: '' }, password: { password: '123456' } }
      expect(response).to redirect_to(login_path)
    end
    it 'should redirect to the login page if email is not database' do
      post :create, { email: { email: 'bobsmith@gmail.com' }, password: { password: '123456' } }
      expect(response).to redirect_to(login_path)
    end
    it 'should redirect to the login page if the email is correct but password is not' do
      post :create, { email: { email: 'admin1@gmail.com' }, password: { password: 'abcdef' } }
      expect(response).to redirect_to(login_path)
    end
    it 'should redirect to dashboard page if the email and password is correct' do
      post :create, { email: { email: 'admin1@gmail.com' }, password: { password: '123456' } }
      expect(response).to redirect_to(admins_path)
    end
    it 'should logout when I click the logout button' do
      post :create, { email: { email: 'admin1@gmail.com' }, password: { password: '123456' } }
      post :destroy, { email: { email: 'admin1@gmail.com' }, password: { password: '123456' } }
      expect(response).to redirect_to(login_path)
    end
    it 'should logout when I close the browser' do
      post :new
      expect(response).to have_http_status(200)
    end
  end
  context "redirect to correct dashboard based on user's role" do
    it 'should redirect to admin page if user is an admin' do
      post :create, { email: { email: 'admin1@gmail.com' }, password: { password: '123456' } }
      expect(response).to redirect_to(admins_path)
    end
    it 'should redirect to nurse page if user is an admin' do
      post :create, { email: { email: 'nurse1@gmail.com' }, password: { password: '123456' } }
      expect(response).to redirect_to(nurses_path)
    end
    it 'should redirect to parent page if user is an admin' do
      post :create, { email: { email: 'parent1a@gmail.com' }, password: { password: '123456' } }
      expect(response).to redirect_to(parents_path)
    end
    it 'should redirect to student page if user is an admin' do
      post :create, { email: { email: 'studenta@gmail.com' }, password: { password: '123456' } }
      expect(response).to redirect_to(students_path)
    end
  end
end