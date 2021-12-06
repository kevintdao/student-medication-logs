Feature:
  As a student
  So that I can make a new medication request
  I want to fill out a form for requesting new medication that need to be verified by the nurse and parent

  Scenario: Request to take a new medication
    Given I am logged in as an "student"
    Given I am on the create request page
    When I enter "Ibuprofen" as "Medication"
    And I select "1" from "daily_doses"
    And I set time for "7:00 AM"
    And I set start date to "12/2/2024"
    And I set end date to "5/4/2025"
    And I click Submit Request
    Then I should be on "student" dashboard

  Scenario: Request to take a new medication with empty medication field
    Given I am logged in as an "student"
    Given I am on the create request page
    When I select "1" from "daily_doses"
    And I set time for "7:00 AM"
    And I set start date to "12/2/2024"
    And I set end date to "5/4/2025"
    And I click Submit Request
    Then I should not be on "student" dashboard

  Scenario: Request to take a new medication with empty Daily Dose field
    Given I am logged in as an "student"
    Given I am on the create request page
    When I enter "Ibuprofen" as "Medication"
    And I set time for "7:00 AM"
    And I set start date to "12/2/2024"
    And I set end date to "5/4/2025"
    And I click Submit Request
    Then I should not be on "student" dashboard

  Scenario: Request to take a new medication with empty Start Date field
    Given I am logged in as an "student"
    Given I am on the create request page
    When I enter "Ibuprofen" as "Medication"
    And I select "1" from "daily_doses"
    And I set time for "7:00 AM"
    And I set end date to "5/4/2025"
    And I click Submit Request
    Then I should not be on "student" dashboard

  Scenario: Request to take a new medication with empty End Date field
    Given I am logged in as an "student"
    Given I am on the create request page
    When I enter "Ibuprofen" as "Medication"
    And I select "1" from "daily_doses"
    And I set time for "7:00 AM"
    And I set start date to "12/2/2024"
    And I click Submit Request
    Then I should not be on "student" dashboard