Feature: Allow users to send a contact email to the development team
  As a user
  So that I can get further information on the SML system
  I want to send a message to the development team with a question

  Scenario: I enter valid information
    Given I am on the contact page
    When I enter "Test Name" as "Your Name"
    When I enter "test@mail.com" as "Your Email"
    When I enter "Cucumber Test" as "Subject"
    When I enter "This is a test from cucumber." as "Message"
    Then I should see the confirmation message

  Scenario: I leave the name field blank
    Given I am on the contact page
    When I enter "test@mail.com" as "Your Email"
    When I enter "Cucumber Test" as "Subject"
    When I enter "This is a test from cucumber." as "Message"
    Then I should not see the confirmation message

  Scenario: I leave the email field blank
    Given I am on the contact page
    When I enter "Test" as "Your Name"
    When I enter "Cucumber Test" as "Subject"
    When I enter "This is a test from cucumber." as "Message"
    Then I should not see the confirmation message

  Scenario: I leave the subject field blank
    Given I am on the contact page
    When I enter "test@mail.com" as "Your Email"
    When I enter "Test" as "Your Name"
    When I enter "This is a test from cucumber." as "Message"
    Then I should not see the confirmation message

  Scenario: I leave the message field blank
    Given I am on the contact page
    When I enter "test@mail.com" as "Your Email"
    When I enter "Cucumber Test" as "Subject"
    When I enter "Test" as "Your Name"
    Then I should not see the confirmation message

  Scenario: I enter an invalid email
    Given I am on the contact page
    When I enter "Test" as "Your Name"
    When I enter "notAnEmail" as "Your Email"
    When I enter "Cucumber Test" as "Subject"
    When I enter "This is a message" as "Message"
    Then I should not see the confirmation message