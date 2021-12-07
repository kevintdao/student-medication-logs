Feature: Nurse can view edit the current inventory items
  As a nurse
  So that I update the inventory
  I want to see be able to update the notes and amount of stock items

  Scenario: Nurse is not logged in

    Given I am on the homepage
    When I visit the inventory page
    Then I should see the landing page

  Scenario: Nurse should see the edit item page

    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the inventory page
    And I click the link called "More Information"
    Then I should see the "Medication Name" page

  Scenario: Nurse can update the medication amount

    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the inventory page
    And I click the link called "More Information"
    And I enter "25\n" into the text box with ID "amount"
    Then I should see the "Medication Name" page

  Scenario: Nurse can update notes

    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the inventory page
    And I click the link called "More Information"
    And I enter "This is a test from Capybara" into the text box with ID "notes"
    And I click submit
    Then I should see the "Medication Name" page

  Scenario: Nurse can delete items

    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the inventory page
    And I click the link called "More Information"
    And I click the link called "Delete Item"
    Then I should see the "Inventory" page