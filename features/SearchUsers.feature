Feature: Search users from the database in current district

Background: Users have been added to database

  Given the following users have been added to SML:

    | first_name    | last_name     | email                   | role        | district_id
    | Admin         | Apple         | admin1@gmail.com        | Admin       | 1
    | Nurse         | Bob           | nurse1@gmail.com        | Nurse       | 1
    | Parent        | Charles       | parent1a@gmail.com      | Parent      | 1
    | Student       | Doe           | student1a@gmail.com     | Student     | 1
    | Student       | Emily         | student1b@gmail.com     | Student     | 1
    | Admin         | Annie         | admin2@gmail.com        | Admin       | 2
    | Nurse         | Banana        | nurse2@gmail.com        | Nurse       | 2
    | Parent        | Caitlyn       | parent2a@gmail.com      | Parent      | 2
    | Student       | Dave          | student2a@gmail.com     | Student     | 2

  And I am on the Users page

  