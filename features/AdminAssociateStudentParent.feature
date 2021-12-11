Feature:
  As an admin
  So that parents are able to verify student medication events
  I want to associate parents and students by completing a form

  Background: Logged in as a admin

    Given I am logged in as an admin
    Given I am on the admin associate page

  Scenario: Correctly select student and parent
    When I select "Student A" from "Student"
    And I select "Parent 1B" from "Parent"
    And I click "submit"
    Then I should see "Student and Parent successfully associated" notice

  Scenario: Input a student and parent that are already associated
    When I select "Student A" from "Student"
    And I select "Parent 1B" from "Parent"
    And I click "submit"
    When I select "Student A" from "Student"
    And I select "Parent 1B" from "Parent"
    And I click "submit"
    Then I should see "Student and Parent are already associated" notice