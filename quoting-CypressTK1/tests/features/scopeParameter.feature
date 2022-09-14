@scope-parameter
Feature: Scope Parameter
  As a template manager
  I should be able to set up scope parameters

  Scenario: The Global Scope Parameters modal should open after clicking Add/Edit Scope Parameters quick action
    Given I am viewing a new estimate template
    When I click the global scope parameters button
    Then I can see the scope parameters modal

  Scenario: The Global Scope Parameters table should have a blank row
    Given I am viewing a new estimate template
    When I click the global scope parameters button
    Then I can see a blank row in the scope parameters table

  Scenario: The Global Scope Parameters table should error when a data type is blank
    Given I am viewing a new estimate template
    When I add a scope parameter named "Test" without a data type
    Then I can see an error in the scope parameters

  Scenario: The Global Scope Parameters table should save scope parameters
    Given I am viewing a new estimate template
    When I add a scope parameter named "Test"
    And I click the global scope parameters button
    Then I can see a scope parameter named "Test" in the scope parameter table

  Scenario: The Scope Parameters modal should launch for an activity group
    Given I am viewing a new estimate template
    And I add an activity group named "Test Activity Group"
    When I click on the scope parameters button
    Then I can see a blank row in the scope parameters table

  Scenario: The Scope Parameters modal should launch for an activity
    Given I am viewing a new estimate template
    And I add an activity group named "Test Activity Group"
    And I add an activity named "Test Activity"
    When I click on the scope parameters button
    Then I can see a blank row in the scope parameters table
