Feature: Allow users to search the medication database by name or ingredient
  As a user
  So that I can see what medications are in the database
  I want to search by name or ingredient and limit the number of results per page

  Scenario: I do not enter a search term
    Given I am on the medication page
    #When I enter "" in the search box
    #And I click search
    Then I should see all medications