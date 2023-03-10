class District < ActiveRecord::Base

  def self.create_district (name, address1, address2, city, state, zipcode)
    district = District.new
    district.district_name = name
    district.address1 = address1
    if (address2 != '') and (address2 != nil)
      district.address2 = address2
    end
    district.city = city
    district.state = state
    district.zipcode = zipcode
    district.save!
    district
  end

  def self.update_district (district, name, address1, address2, city, state, zipcode)
    district.update!(
      district_name: name,
      address1: address1,
      address2: address2,
      city: city,
      state: state,
      zipcode: zipcode)
  end
end
