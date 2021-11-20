Feature: Search users from the database in current district

Background: Users have been added to database

  Given the following users have been added to SML:

    | first_name    | last_name     | email                   | password    | role        | district_id
    | Admin         | Apple         | admin1@gmail.com        | 123456      | Admin       | 1
    | Nurse         | Bob           | nurse1@gmail.com        | 123456      | Nurse       | 1
    | Parent        | Charles       | parent1a@gmail.com      | 123456      | Parent      | 1
    | Student       | Doe           | student1a@gmail.com     | 123456      | Student     | 1
    | Student       | Emily         | student1b@gmail.com     | 123456      | Student     | 1
    | Admin         | Annie         | admin2@gmail.com        | 123456      | Admin       | 2
    | Nurse         | Banana        | nurse2@gmail.com        | 123456      | Nurse       | 2
    | Parent        | Caitlyn       | parent2a@gmail.com      | 123456      | Parent      | 2
    | Student       | Dave          | student2a@gmail.com     | 123456      | Student     | 2

  And I am on the Users page

Scenario: restrict to user with first name of 'Admin'
  When I search by "Name" for the term "admin"
  Then I should see user with the name of "Admin"
  And I should not see user with the name of "Student"

Scenario: restrict to user with name of 'Student Doe'
  When I search by "Name" for the term "Student Doe"
  Then I should see user with the name of "Student Doe"
  And I should not see user with the name of "Student Emily"

Scenario: restrict to user with role of 'Student'
  When I search by "Role" for the term "student"
  Then I should see user with the name of "Student"
  And I should not see user with the name of "Admin"
