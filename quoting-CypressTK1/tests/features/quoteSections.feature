@quote-sections
Feature: Quote Sections
  As a quote manager
  I should be able add resources under sections in a quote

  Scenario: A default section should be created for a new quote when Section Hierarchy = Simple
     Given I have created a quote with a Section Hierarchy of "Simple"
     And I visit the quote
     Then I can see that a default section has been created
