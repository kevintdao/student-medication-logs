Feature: Nurse can view current inventory
  As a nurse
  So that I can see all the medication in stock
  I want to see a searchable list of the current inventory

  Scenario: Nurse is not logged in

    Given I am on the homepage
    When I visit the inventory page
    Then I should see the landing page

  Scenario: Nurse is logged in

    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the inventory page
    Then I should see the "Inventory" page

  Scenario: Other user type is logged in

    Given I am on the login page
    When I login with email = "admin1@gmail.com", password = "123456"
    And I visit the inventory page
    Then I should see the landing page


  Scenario: I do not enter a search term
    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the inventory page
    And I enter "" in the search box
    And I click search
    Then I should see the "Inventory" page

  Scenario: I view a specific medication
    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the inventory page
    And I click the link called "More Information"
    Then I should see the "Medication Name" page