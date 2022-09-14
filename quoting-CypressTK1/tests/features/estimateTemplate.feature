@estimate-template
Feature: Estimate Template
  As a estimate manager
  I should be able create an estimate template

  Scenario: An Estimate Template should be created
    Given I have created an estimate template
    When I visit the estimate template
    Then I can see the activity group creation button

  Scenario: The Activity Group creation modal should open after clicking the button
    Given I have created an estimate template
    And I visit the estimate template
    When I click on the activity group creation button
    Then I can see the activity group creation modal

  Scenario: An Activity Group is added to the table
    Given I have created an estimate template
    And I visit the estimate template
    When I add an activity group named "Test Activity Group"
    Then I can see a row named "Test Activity Group" in the table

  Scenario: The Activities modal should open after clicking Add/Edit Activities
    Given I have created an estimate template
    And I visit the estimate template
    And I add an activity group named "Test Activity Group"
    When I click on the activities button
    Then I can see the activities modal for "Test Activity Group"

  Scenario: An activity is added to the table
    Given I have created an estimate template
    And I visit the estimate template
    And I add an activity group named "Test Activity Group"
    When I add an activity named "Test Activity"
    Then I can see a row named "Test Activity" in the table
