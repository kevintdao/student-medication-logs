Feature: Nurse can view all forms (complete and incomplete)
  As a parent
  So that I can approve forms from the school nurse
  I want to be able to read a form, click a button, and have it approved

  Scenario: Parent is not logged in
    Given I am on the login page
    When I login with email = "studentb@gmail.com", password = "123456"
    When I visit the forms page
    Then I should see the landing page


  Scenario: Parent views an approved form
    Given I am on the login page
    When I login with email = "parent1a@gmail.com", password = "123456"
    And I visit the parent forms page
    Then I should see the "Forms for Iowa City Community Schools" page