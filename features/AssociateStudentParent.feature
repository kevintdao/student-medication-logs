Feature:
  As a nurse
  So that parents are able to verify student medication events
  I want to associate parents and students by completing a form

  Background: Logged in as a nurse

    Given I am logged in as a nurse
    Given I am on the associate page

  Scenario: Correctly select student and parent
    When I select "Student A" in "student" menu
    And I select "Parent 2" in "parent" menu
    And I click "submit"
    Then I should see "Student and Parent successfully associated" notice

  Scenario: Input a student and parent that are already associated
    When I select "Student A" in "student" menu
    And I select "Parent 2" in "parent" menu
    And I click "submit"
    When I select "Student A" in "student" menu
    And I select "Parent 2" in "parent" menu
    And I click "submit"
    Then I should see "Student and Parent are already associated" notice


