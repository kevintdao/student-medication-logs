Feature:
  As a admin with an account
  So that I can request users join the system
  I want to have a page to create an account and invite a new user


  Scenario: Invite a new user to the School District
    Given I am logged in as an admin
    Given I am on the create users page
    When I select "Nurse" from "User Type"
    And I enter "William" as "First Name"
    And I enter "Robert" as "Last Name"
    And I enter "test.user@email.com" as "Email Address"
    And I click Invite User
    Then The database should contain a user with the email "test.user@email.com"
    And "test.user@email.com" should receive an email with subject "Set Password For SML"

  Scenario: New User receives email and sets up password
    Given I am logged in as an admin
    Given I am on the create users page
    When I select "Nurse" from "User Type"
    And I enter "William" as "First Name"
    And I enter "Robert" as "Last Name"
    And I enter "test.user@email.com" as "Email Address"
    And I click Invite User
    And "test.user@email.com" should receive an email with subject "Set Password For SML"
    When they open the email
    Then they should see "Set Password" in the email body
    When they follow "Set Password" in the email
    Then they should see "Set an Account Password"
    When they enter "hi1234" as "Password"
    And they enter "hi1234" as "Password Confirmation"
    And they click Set Password
    Then they should be on the login page


  Scenario: New User receives email and sets up password with wrong password confirmation
    Given I am logged in as an admin
    Given I am on the create users page
    When I select "Nurse" from "User Type"
    And I enter "William" as "First Name"
    And I enter "Robert" as "Last Name"
    And I enter "test.user@email.com" as "Email Address"
    And I click Invite User
    And "test.user@email.com" should receive an email with subject "Set Password For SML"
    When they open the email
    Then they should see "Set Password" in the email body
    When they follow "Set Password" in the email
    Then they should see "Set an Account Password"
    When they enter "hi1234" as "Password"
    And they enter "helloworld" as "Password Confirmation"
    And they click Set Password
    Then they should not be on the login page

  Scenario: Admin leaves first name field empty when creating a user
    Given I am logged in as an admin
    Given I am on the create users page
    When I select "Nurse" from "User Type"
    And I enter "Robert" as "Last Name"
    And I enter "test.user@email.com" as "Email Address"
    And I click Invite User
    And "test.user@email.com" should receive no email with subject "Set Password For SML"

  Scenario: Admin leaves last name field empty when creating a user
    Given I am logged in as an admin
    Given I am on the create users page
    When I select "Nurse" from "User Type"
    And I enter "William" as "First Name"
    And I enter "test.user@email.com" as "Email Address"
    And I click Invite User
    And "test.user@email.com" should receive no email with subject "Set Password For SML"

  Scenario: Admin leaves email field empty when creating a user
    Given I am logged in as an admin
    Given I am on the create users page
    When I select "Nurse" from "User Type"
    And I enter "William" as "First Name"
    And I enter "Robert" as "Last Name"
    And I click Invite User
    And "test.user@email.com" should receive no email with subject "Set Password For SML"

