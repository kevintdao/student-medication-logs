Feature:
  As an Admin
  So that I can edit personal information about myself
  I want to have a settings page to edit my account info

  Scenario: Change my first name in the account as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "First Name" in the input box
    When I change my "First Name" to "Heather"
    Then I should see "Heather" as my "First Name" on the page

  Scenario: Change my last name in the account as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "Last Name" in the input box
    When I change my "Last Name" to "Smith"
    Then I should see "Smith" as my "Last Name" on the page

  Scenario: Change my email in the account as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "Email Address" in the input box
    When I change my "Email Address" to "newadmin@gmail.com"
    Then I should see "newadmin@gmail.com" as my "Email Address" on the page

  Scenario: Enable email notifications as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "Enable Email Notifications" in the input box
    When I change my "Enable Email Notifications" to "true"
    Then I should see "true" as my "Enable Email Notifications" on the page

  Scenario: Enable text notifications as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "Enable Text Notifications" in the input box
    When I change my "Enable Text Notifications" to "true"
    Then I should see "true" as my "Enable Text Notifications" on the page

  Scenario: Change my phone number as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "Phone Number" in the input box
    When I change my "Phone Number" to "3194550011"
    Then I should see "3194550011" as my "Phone Number" on the page

  Scenario: Change the district name as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "District Name" in the input box
    When I change my "District Name" to "New York School"
    Then I should see "New York School" as my "District Name" on the page

  Scenario: Change the district address as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "Address" in the input box
    When I change my "Address" to "1234 Avenue"
    Then I should see "1234 Avenue" as my "Address" on the page

  Scenario: Change the district city as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "City" in the input box
    When I change my "City" to "New York"
    Then I should see "New York" as my "City" on the page

  Scenario: Change the district state as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "State" in the input box
    When I change my "State" to "New York"
    Then I should see "NY" as my "State" on the page

  Scenario: Change the district zipcode as an admin
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "Zip Code" in the input box
    When I change my "Zip Code" to "85485"
    Then I should see "85485" as my "Zip Code" on the page

  Scenario: Wrong phone number format is entered
    Given I am logged in as an "admin"
    Given I am on the edit users page
    Then I should see my "Phone Number" in the input box
    When I change my "Phone Number" to "1"
    Then I should not see a different "Phone Number"