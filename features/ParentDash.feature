Feature: Allow users who are a parents to view information specific to them
  As a parent
  So that I can see my personal information
  I want to have a dashboard with links to events, medications, students, and forms

  Background: Logged in as a parent
    Given I am logged in as an "parent"

  Scenario: I can see the dashboard
    Given I am on the parent dashboard
    Then I should see the parent dashboard

  Scenario: I can click the medications button
    Given I am on the parent dashboard
    When I click the link called "All Medications"
    Then I should see a page with content "Medications"