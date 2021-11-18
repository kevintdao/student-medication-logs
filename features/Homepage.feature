Feature: Provide a landing page to registered and non-registered users
  As a user
  So that I can obtain information and access the SML system
  I want to see a landing page when I navigate to the application

  Scenario: See the correct homepage

    Given I am on the homepage
    When I click the SML logo
    Then I should see the landing page

  Scenario: I can navigate to the about page
    Given I am on the homepage
    When I click the About link
    Then I should see the About page

  Scenario: I can navigate to the medications page
    Given I am on the homepage
    When I click the Medications link
    Then I should see the Medications page

  Scenario: I can navigate to the contact us page
    Given I am on the homepage
    When I click the Contact link
    Then I should see the Contact Us page