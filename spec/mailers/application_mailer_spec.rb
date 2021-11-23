require 'spec_helper'
require 'rails_helper'

describe ApplicationMailer do
  describe 'sends set password email', :type => :mailer do
    let(:mail) { ApplicationMailer.set_password(@the_user) }
    before :all do
      @the_user = User.where(:email => 'studenta@gmail.com')[0]
      @the_user.password = '123456'
      @the_user.password_confirmation = '123456'
      @the_user.password_set_token = SecureRandom.urlsafe_base64
      @the_user.password_set_sent_at = Time.zone.now
      @the_user.save!
    end
    it 'sends an email' do
      expect { ApplicationMailer.set_password(@the_user).deliver }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
    it 'sets the subject, to, from' do
      expect(mail.subject).to eq('Set Password For SML')
      expect(mail.to).to eq([@the_user.email])
      expect(mail.from).to eq(['contact.sml.team@gmail.com'])
    end
    it 'contains a link to set new password' do
      expect(mail.body.encoded).to match(edit_password_set_url @the_user.password_set_token)
    end
  end
end