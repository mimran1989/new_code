@project-Milestone
@feature-flag[ProjectMilestone:on]
Feature: Project Milestones
  As a quote manager
  I should be able add and delete project milestones

  Background: I am on the milestones tab
    Given I have created a quote
    And I visit the quote
    And I visit the Milestones tab

  Scenario: The Milestones tab should show the milestones table
    Then I can see the milestones table

  Scenario: Clicking new should launch the Create New Milestone flow
    When I click New
    Then I can see the Create new milestones modal

  Scenario: Add a new milestone aligned to date
    When I add a new milestone "Test" aligned to date on "1/1/2022"
    Then I can see a milestone named "Test" in the milestones table

  Scenario: Selecting a row and clicking delete should confirm delete of milestones
    And I add a new milestone "Test 2" aligned to date on "1/3/2022"
    When I select all milestones
    And I delete the milestones
    Then I will see a confirmation to delete the milestones

  Scenario: Selecting a row and clicking delete should delete the milestone
    And I add a new milestone "Test 2" aligned to date on "1/3/2022"
    And I can see a milestone named "Test 2" in the milestones table
    When I delete all the milestones
    Then I can no longer see milestones in the table

  Scenario: Add a new Milestone aligned to another Milestone
    And I add a new milestone "Test 1" aligned to date on "1/1/2022"
    When I add a new milestone "Test 2" aligned to milestone "Test 1"
    Then I can see a milestone named "Test 2" aligned to a milestone named "Test 1" in the milestones table
  Scenario: Add a new Milestone without specifying another Milestone
    When I add a new milestone "Test 2" aligned to milestone "--None--"
    Then I can see the Create new milestones modal

  Scenario: Add a new milestone Aligned to Project Activity
    When I add a new milestone "Test" aligned to "Start of Period" of period 1
    Then I can see a milestone named "Test" aligned to last selected period in the milestones table

  Scenario: Add a new milestone Aligned to Project Activity - Period Group
    When I add a new milestone "Test" aligned to "Start of Period Group" of period group 1
    Then I can see a milestone named "Test" aligned to last selected period group in the milestones table

  Scenario: Add a new Milestone aligned to another Milestone without specifying an Offset Unit
    And I add a new milestone "Test 1" aligned to date on "1/1/2022"
    When I add a new milestone "Test 2" aligned to milestone "Test 1" with a 2 "Days" offset
    Then I can see the Create new milestones modal

  Scenario: Add a new Milestone aligned to another Milestone with a 2 day offset
    And I add a new milestone "Test 1" aligned to date on "1/1/2022"
    When I add a new milestone "Test 2" aligned to milestone "Test 1" with a 2 "Days" offset
    Then I can see a milestone named "Test 2" with an "Estimated Occurrence Date" of "1/3/2022" in the table

  Scenario: Add a new Milestone aligned to another Milestone with a 2 weeks offset
    And I add a new milestone "Test 1" aligned to date on "1/1/2022"
    When I add a new milestone "Test 2" aligned to milestone "Test 1" with a 2 "Weeks" offset
    Then I can see a milestone named "Test 2" with an "Estimated Occurrence Date" of "1/15/2022" in the table

  Scenario: Add a new Milestone aligned to another Milestone with a 2 month offset
    And I add a new milestone "Test 1" aligned to date on "1/1/2022"
    When I add a new milestone "Test 2" aligned to milestone "Test 1" with a 2 "Months" offset
    Then I can see a milestone named "Test 2" with an "Estimated Occurrence Date" of "3/1/2022" in the table

  Scenario: Add a new Milestone aligned to another Milestone with a 2 quarters offset
    And I add a new milestone "Test 1" aligned to date on "1/1/2022"
    When I add a new milestone "Test 2" aligned to milestone "Test 1" with a 2 "Quarters" offset
    Then I can see a milestone named "Test 2" with an "Estimated Occurrence Date" of "7/1/2022" in the table

  Scenario: Add a new Milestone aligned to another Milestone with a 2 years offset
    And I add a new milestone "Test 1" aligned to date on "1/1/2022"
    When I add a new milestone "Test 2" aligned to milestone "Test 1" with a 2 "Years" offset
    Then I can see a milestone named "Test 2" with an "Estimated Occurrence Date" of "1/1/2024" in the table
