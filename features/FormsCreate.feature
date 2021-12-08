Feature: Nurse can create and automatically approve new forms
  As a nurse
  So that I create a new form for approval by the parent
  I want to be able to type a new form into a text field and send it to the parent/guardian

  Scenario: Nurse is not logged in
    Given I am on the homepage
    When I visit the new form page
    Then I should see the landing page

  Scenario: Nurse is logged in
    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the new form page
    Then I should see the "New Form" page

  Scenario: Another user type is logged in
    Given I am on the login page
    When I login with email = "parent1a@gmail.com", password = "123456"
    And I visit the new form page
    Then I should see the landing page

  Scenario: Nurse can create a new form

    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the new form page
    And I enter "This is a test created by cucumber" into the text box with ID "body"
    And I click submit
    Then I should see the "Forms" page