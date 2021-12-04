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
  describe 'updating a district' do
    before :all do
      @district = District.all[0]
    end
    it 'should update the district_name field' do
      old_district_name = @district.district_name
      new_district_name = 'newname'
      District.update_district(@district, new_district_name, @district.address1, @district.address2, @district.city, @district.state, @district.zipcode)
      expect(District.find(@district.id).district_name).to eq(new_district_name)
      expect(District.find(@district.id).district_name).not_to eq(old_district_name)
    end
    it 'should update the address1 field' do
      old_address1 = @district.address1
      new_address1 = 'address new'
      District.update_district(@district, @district.district_name, new_address1, @district.address2, @district.city, @district.state, @district.zipcode)
      expect(District.find(@district.id).address1).to eq(new_address1)
      expect(District.find(@district.id).address1).not_to eq(old_address1)
    end
    it 'should update the address2 field' do
      old_address2 = @district.address2
      new_address2 = 'address2 new'
      District.update_district(@district, @district.district_name, @district.address1, new_address2, @district.city, @district.state, @district.zipcode)
      expect(District.find(@district.id).address2).to eq(new_address2)
      expect(District.find(@district.id).address2).not_to eq(old_address2)
    end
    it 'should update the city field' do
      old_city = @district.city
      new_city = 'Washington'
      District.update_district(@district, @district.district_name, @district.address1, @district.address2, new_city, @district.state, @district.zipcode)
      expect(District.find(@district.id).city).to eq(new_city)
      expect(District.find(@district.id).city).not_to eq(old_city)
    end
    it 'should update the state field' do
      old_state = @district.state
      new_state = 'DE'
      District.update_district(@district, @district.district_name, @district.address1, @district.address2, @district.city, new_state, @district.zipcode)
      expect(District.find(@district.id).state).to eq(new_state)
      expect(District.find(@district.id).state).not_to eq(old_state)
    end
    it 'should update the zipcode field' do
      old_zipcode = @district.zipcode
      new_zipcode = '52234'
      District.update_district(@district, @district.district_name, @district.address1, @district.address2, @district.city, @district.state, new_zipcode)
      expect(District.find(@district.id).zipcode).to eq(new_zipcode)
      expect(District.find(@district.id).zipcode).not_to eq(old_zipcode)
    end
  end
end