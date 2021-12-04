Feature: User sign in to their account

Background: I am on the home page
  Given I am on the homepage

Scenario: Login page
  When I click "Login"
  Then I should see the "Login" page

Scenario: Login with the empty email/password
  When I click "Login"
  And I login with email = "", password = ""
  Then I should see "Email and/or password field are blank" notice

Scenario: Login with the wrong email/password combination
  When I click "Login"
  And I login with email = "admin1@gmail.com", password = "abcdef"
  Then I should see "Invalid email/password combination" notice

Scenario: Login with the correct email/password
  When I click "Login"
  And I login with email = "admin1@gmail.com", password = "123456"
  Then I should see "Successfully login! You are logged in as admin1@gmail.com" notice
