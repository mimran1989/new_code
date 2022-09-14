Feature: Volume Discounts Summary

#  @PSQ-4154
#  Scenario: Quote Level Earned Volume Discount
#    Given I am on a $10,000,000 quote with a total headcount of 16
#    And the the following headcount volume discount tiers have been setup:
#      | Tier # | Min Headcount | Max Headcount | Discount % |
#      | 1      | 0             | 16            | 9%         |
#    When the user views the volume discount summary
#    Then a volume discount amount of $900,000 is applied to the quote
#
#  @PSQ-4154
#  Scenario: Volume Discount Multi-Period Summary
#    Given I am on a quote with the following quarterly period revenue:
#      | Period | Revenue |
#      | Qtr 1  | $2,000  |
#      | Qtr 2  | $25,000 |
#      | Qtr 3  | $50,000 |
#    And the following period revenue volume discount tiers are setup:
#      | Tier | Tier Min | Tier Max | Discount % |
#      | 1    | $2,500   | $10,000  | 2%         |
#      | 2    | $10,001  | $30,000  | 5%         |
#      | 3    | $30,001  | $999,999 | 10%        |
#    When the user views the volume discount summary
#    Then the following volume discounts are displayed in the volume discounts summary:
#      | Period | Base on | Active tier | Min revenue | Max revenue | Discount % | Revenue | Discount amount |
#      | Qtr 2  | Revenue | 2           | $10,000     | $30,000     | 5%         | $25,000 | $1,250          |
#      | Qtr 3  | Revenue | 3           | $30,001     | $999,999    | 10%        | $50,000 | $5,000          |
