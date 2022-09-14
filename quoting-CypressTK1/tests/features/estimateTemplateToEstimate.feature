 @estimate-template-estimate-flow
 Feature: Estimate Template to Estimate Conversion
   As an estimate template manager
   I should be able to convert an estimate template into an estimate

   Scenario: An Estimate should be created from an Estimate Template
     Given I am viewing an estimate template with data
     When I click the New Estimate button
     Then I should be redirected to the created estimate
