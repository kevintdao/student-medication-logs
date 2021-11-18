require 'spec_helper'
require 'rails_helper'

describe District do
  describe 'creating a district' do
    it 'should save a district to the database with no address2 value' do
      pre_call_length = District.all.length
      district = District.create_district('New Lake Schools', '1234 1st Avenue', nil, 'Lakewood', 'IA', '52253')
      post_call_length = District.all.length
      expect(post_call_length).to eq(pre_call_length + 1)
      expect(District.find(district.id).district_name).to eq('New Lake Schools')
      expect(District.find(district.id).address2).to eq(nil)
    end
    it 'should save a district to the database with address2 value' do
      pre_call_length = District.all.length
      district = District.create_district('New Lake Schools', '1234 1st Avenue', 'Apartment 1', 'Lakewood', 'IA', '52253')
      post_call_length = District.all.length
      expect(post_call_length).to eq(pre_call_length + 1)
      expect(District.find(district.id).district_name).to eq('New Lake Schools')
      expect(District.find(district.id).address2).to eq('Apartment 1')
    end
  end
end