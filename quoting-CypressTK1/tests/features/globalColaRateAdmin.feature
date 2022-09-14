@global-cola-rate-admin
@feature-flag[ColaAdjustment:on]
Feature: Global Cola Rate Admin / Cola Rates By Location
  As a pricing manager
  I should be able to set up the global cola rates for various locations

  Scenario: The Cola Rates by Location tab should show the rate table
    Given I visit the COLA Rates by Location tab
    Then I should see the COLA Rates table