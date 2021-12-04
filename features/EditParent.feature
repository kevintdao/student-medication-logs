Feature:
  As a Parent
  So that I can edit personal information about myself
  I want to have a settings page to edit my account info

  Scenario: Change my first name in the account as an parent
    Given I am logged in as an "parent"
    Given I am on the edit users page
    Then I should see my "First Name" in the input box
    When I change my "First Name" to "Heather"
    Then I should see "Heather" as my "First Name" on the page

  Scenario: Change my last name in the account as an parent
    Given I am logged in as an "parent"
    Given I am on the edit users page
    Then I should see my "Last Name" in the input box
    When I change my "Last Name" to "Smith"
    Then I should see "Smith" as my "Last Name" on the page

  Scenario: Change my email in the account as an parent
    Given I am logged in as an "parent"
    Given I am on the edit users page
    Then I should see my "Email Address" in the input box
    When I change my "Email Address" to "newparent@gmail.com"
    Then I should see "newparent@gmail.com" as my "Email Address" on the page

  Scenario: Enable email notifications as an parent
    Given I am logged in as an "parent"
    Given I am on the edit users page
    Then I should see my "Enable Email Notifications" in the input box
    When I change my "Enable Email Notifications" to "true"
    Then I should see "true" as my "Enable Email Notifications" on the page

  Scenario: Enable text notifications as an parent
    Given I am logged in as an "parent"
    Given I am on the edit users page
    Then I should see my "Enable Text Notifications" in the input box
    When I change my "Enable Text Notifications" to "true"
    Then I should see "true" as my "Enable Text Notifications" on the page

  Scenario: Change my phone number as an parent
    Given I am logged in as an "parent"
    Given I am on the edit users page
    Then I should see my "Phone Number" in the input box
    When I change my "Phone Number" to "3194550011"
    Then I should see "3194550011" as my "Phone Number" on the page

  Scenario: Wrong phone number format is entered
    Given I am logged in as an "parent"
    Given I am on the edit users page
    Then I should see my "Phone Number" in the input box
    When I change my "Phone Number" to "1"
    Then I should not see a different "Phone Number"