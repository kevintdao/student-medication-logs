Feature: Search users from the database in current district

Background: Users have been added to database
  Given I am logged in as an admin
  And I am on the Users page

Scenario: restrict to user with first name of 'Admin'
  When I search by "Name" for the term "admin"
  Then I should see user with the name of "Admin"
  And I should not see user with the name of "Student"

Scenario: restrict to user with name of 'Student Doe'
  When I search by "Name" for the term "Student A"
  Then I should see user with the name of "Student A"
  And I should not see user with the name of "Student B"

Scenario: restrict to user with role of 'Student'
  When I search by "Role" for the term "student"
  Then I should see user with the name of "Student"
  And I should not see user with the name of "Admin"
