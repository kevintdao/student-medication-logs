Feature: Allow users who are a students to view information specific to them
  As a Student
  So that I can see my personal information
  I want to have a dashboard with links to events, medications, students, and forms

  Scenario: I can see the dashboard
    Given I am on the student dashboard
    Then I should see the student dashboard

  Scenario: I can click the upcoming events button
    Given I am on the student dashboard
    When I click the link called "Upcoming Events"
    Then I should see a page with content "Incomplete Events"

  Scenario: I can click the past events button
    Given I am on the student dashboard
    When I click the link called "Past Events"
    Then I should see a page with content "Completed Events"

  Scenario: I can click the medications button
    Given I am on the student dashboard
    When I click the link called "All Medications"
    Then I should see a page with content "Medications"