Feature: Nurse can view all forms (complete and incomplete)
  As a nurse
  So that I can see all the forms in the database
  I want to see a list of forms that can be searched

  Scenario: Nurse is not logged in
    #  We are no longer allowing this
    Given I am on the login page
    When I login with email = "parent1a@gmail.com", password = "123456"
    When I visit the forms page
    Then I should see the landing page

  Scenario: Nurse is logged in
    # In the future this will be a different path than another logged in user. For now it is the same
    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    When I visit the forms page
    Then I should see the "Forms" page

  Scenario: I do not enter a search term
    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the forms page
    And I enter "" in the search box
    And I click search
    Then I should see the "Forms" page

  Scenario: I view a specific form
    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the forms page
    And I click the link called "More Information"
    Then I should see the "Form approved by Guardian" page