Feature:
  As a nurse
  So that I can allow a student to take a medication
  I want to verify a students request to take medication

  Background:
    Given A request by "Student A" has been made

  Scenario: Parent has already approved Request
    Given I am logged in as an "nurse"
    When I am on the nurse dashboard
    Then I should see "You have medication requests awaiting your approval."
    When I click the View Requests for Approval button
    Then I should be on the requests page
    Then I should see the request for "Student A" to take "Ibuprofen" with " 3 " daily doses
    When I click Approve Request for "Student A" with "3" daily doses
    Then I should see "Successfully approved. Medication Events have been created."
    Then The request for "Student A" with "3" daily doses should be "nurse" approved and "parent" approved

  Scenario: Parent has not approved Request
    Given I am logged in as an "nurse"
    When I am on the nurse dashboard
    Then I should see "You have medication requests awaiting your approval."
    When I click the View Requests for Approval button
    Then I should be on the requests page
    Then I should see the request for "Student A" to take "Benadryl" with " 2 " daily doses
    When I click Approve Request for "Student A" with "2" daily doses
    Then I should see "Successfully approved."
    Then The request for "Student A" with "2" daily doses should be "nurse" approved and "not parent" approved

