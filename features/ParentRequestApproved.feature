Feature:
  As a parent
  So that my student can take a medication
  I want to verify my students request

  Background:
    Given "Student A" is a child of "Parent 1A"
    Given A request by "Student A" has been made that is not verified by Parent or Nurse

  Scenario: Nurse has already approved Request
    Given I am logged in as an "parent"
    When I am on the parent dashboard
    Then I should see "You have medication requests awaiting your approval."
    When I click the View Requests for Approval button
    Then I should be on the requests page
    Then I should see the request for "Student A" to take "PAREDRINE" with " 4 " daily doses
    When I click Approve Request for "Student A" with "4" daily doses
    Then I should see "Successfully approved. Medication Events have been created."
    Then The request for "Student A" with "4" daily doses should be "parent" approved and "nurse" approved

  Scenario: Nurse has not approved Request
    Given I am logged in as an "parent"
    When I am on the parent dashboard
    Then I should see "You have medication requests awaiting your approval."
    When I click the View Requests for Approval button
    Then I should be on the requests page
    Then I should see the request for "Student A" to take "Benadryl" with " 2 " daily doses
    When I click Approve Request for "Student A" with "2" daily doses
    Then I should see "Successfully approved."
    Then The request for "Student A" with "2" daily doses should be "parent" approved and "not nurse" approved

