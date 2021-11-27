Feature: User sign out of their account

Scenario: No logout button
  When I am on the homepage
  Then I should not see "Logout" button

Scenario: Logout button for existing account
  Given I am on the login page
  When I login with email = "admin1@gmail.com", password = "123456"
  Then I should see "Logout" button

Scenario: Logout button for existing account
  Given I am on the login page
  And I login with email = "admin1@gmail.com", password = "123456"
  When I click "Logout"
  Then I should see "Successfully logged out!" notice
  And I should not see "Logout" button