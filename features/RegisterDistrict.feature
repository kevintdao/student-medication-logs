Feature: Allow user to register a school district and create admin account
  As an unregistered user
  So that I can access admin functionality
  I want to register my school district


Scenario: Register a school district and admin

  Given I am on the District Registration page

  When I enter "Mount Vernon Schools" as "District Name"
  And I enter "1234 Palisades Rd" as "Address"
  And I enter "Mount Vernon" as "City"
  And I enter "Iowa" as "State"
  And I enter "52314" as "Zip Code"
  And I enter "Alberta" as "First Name"
  And I enter "Clayton" as "Last Name"
  And I enter "aclayton@gmail.com" as "Email Address"
  And I enter "hi1234" as "Password"
  And I enter "hi1234" as "Confirm Password"

  When I click Register District
  Then The database should contain a school district with the name "Mount Vernon Schools" and an admin with the email "aclayton@gmail.com"
  And I should be on the login page