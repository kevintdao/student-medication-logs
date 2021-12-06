Feature: Nurse add items to the inventory
  As a nurse
  So that I create new inventory items
  I want to see be able to fill out a form to create a new inventory item

  Scenario: Nurse is not logged in

    Given I am on the homepage
    When I visit the inventory page
    Then I should see the landing page

  Scenario: Nurse should see the add item

    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the inventory page
    And I click the link called "Add an Item to Inventory"
    Then I should see the "New Inventory Item" page

  Scenario: Nurse can create a new item

    Given I am on the login page
    When I login with email = "nurse1@gmail.com", password = "123456"
    And I visit the inventory page
    And I click the link called "Add an Item to Inventory"
    And I enter "Ibuprofen" into the text box with ID "name"
    And I enter "250" into the text box with ID "amount"
    And I enter "This is created by capybara test" into the text box with ID "notes"
    And I click submit
    Then I should see the "Inventory" page


