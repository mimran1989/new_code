@rate-card
Feature: Ratecard Functionality
  Verify RateCard Functionality

    # Scenario Outline: Create 5 Resource Role and 1 Ancillary product
    # Given I click "Products" button
    # Then I select record type as "<RecordType>"
    # Then I enter product name as "<ProductName>"
    # Then I select practice as "<practice>"
    # Then I select group as "<group>"
    # Examples:
    # | RecordType    | ProductName             | practice | group |
    # | Ancillary     | Ancillary Product       | Oracle   | ERP   |
    # | Resource Role | Resource Role Product 1 | Oracle   | ERP   |
    # | Resource Role | Resource Role Product 2 | Oracle   | ERP   |
    # | Resource Role | Resource Role Product 3 | Oracle   | ERP   |
    # | Resource Role | Resource Role Product 4 | Oracle   | ERP   |
    # | Resource Role | Resource Role Product 5 | Oracle   | ERP   |
 
    
    @Only
    Scenario: Verify Error Message for effective date while creating rate card    
    Given I enter new rate card name only "Rate Card Test 5/April,1"
    # Then I verify error message for effective date
    
    
    # Scenario: Create a Rate Card
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,2" effective on "3/15/2022" and expiring on "12/31/2022"
 
    
    # Scenario: Create a Rate Card and validate rate card in quote
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,3" effective on "4/4/2022" and expiring on "12/31/2022"
    # Then I click "Quotes" button
    # When I add a new quote named "Quote Test 5/April,3" service start date as "4/4/2022" and enter "Rate Card Test 5/April,3" in quote
    # Then I verify rate card in quote "Rate Card Test 5/April,3"
 
    
    # Scenario: Error message we hit snag should be display in absence of effective date and expiration dates value in New Rate card
    # Given I click "Rate Cards" button
    # When I enter new rate card name only "Rate Card Test 5/April,4"
    # Then I verify we hit snag error message
    
    
    # Scenario: Create a Rate Card and then create a quote
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,5" effective on "4/4/2022" and expiring on "12/31/2022"
    # Then I click "Quotes" button
    # When I add a new quote named "Quote Test 5/Aprl,5" service start date as "4/4/2022" and service end date as "12/31/2022"
    # Then I select rate card as "Rate Card Test 5/April,5" time periods alignment as "Calendar" time periods as "Months" and time periods group method as "Year" 
    
    
    # Scenario: Effective date should be less than expiration date in New Rate card
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,6" effective on "4/18/2022" and expiring on "4/14/2022"
    # Then I verify error message effective date as the Rate Card effective date cannot be greater than Rate Card expiration date

    
    # Scenario: Error message should be display in absence of expiration dates value missing in New Rate card
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,7" effective on "4/18/2022" with no expiring date
    # Then I verify we hit snag error message

    
    # Scenario: Error message should be display in absence of effective dates value missing in New Rate card
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,8" with no effective date and expiring on "4/18/2022"
    # Then I verify we hit snag error message

    
    # Scenario: Verify when user entered incorrect effective date in Rate card error message should be displayed
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,9" effective on "2/11/22" and expiring on "3/18/2022"
    # Then I will verify error as your entry does not match the allowed format

    
    # Scenario: Display the Effective Date and Expiration Date field in New Rate card as mandatory
    # Given I click "Rate Cards" button
    # When I enter new rate card name only "Rate Card Test 5/April,10"
    # Then I verify error message for effective date
    # Then I verify error message for expiry date

    
    # Scenario: Verify to check if quote service start date is within the range of rate card effective dates, Actor should be able to add the rate card in quote
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,11" effective on "4/4/2022" and expiring on "12/31/2022"
    # Then I click "Quotes" button
    # When I add a new quote named "Quote Test 5/Aprl,11" service start date as "4/4/2022" and service end date as "12/31/2022"
    # Then I select rate card as "Rate Card Test 5/April,11" time periods alignment as "Calendar" time periods as "Months" and time periods group method as "Year" 

    
    # Scenario: Verify if No service start date is selected while creating quote, user should not be able to add any rate card
    # Given I click "Quotes" button      
    # When I enter new quote name only "Rate Card Test 5/April,12"
    # Then I verify new rate card in dropdown

    
    # Scenario: Verify if service start date in quote is less than the effective date on rate card, the rate card should not be allowed to be used in quote
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,13" effective on "4/10/2022" and expiring on "4/11/2022"
    # Then I click "Quotes" button
    # When I add a new quote named "Quote Test 5/Aprl,13" service start date as "4/9/2021" and rate card as "Rate Card Test 5/April,13"
    # Then I verify new rate card in dropdown

    
    # Scenario: Verify if service start date in quote is greater than the expiration date on rate card, the rate card should not be allowed to be used in quote
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,14" effective on "4/10/2022" and expiring on "4/11/2022"
    # Then I click "Quotes" button
    # When I add a new quote named "Quote Test 5/Aprl,14" service start date as "4/12/2021" and rate card as "Rate Card Test 5/April,14"
    # Then I verify new rate card in dropdown

    
    # Scenario: Verify if rate card expiration date is same as service start date in quote, user should be able to add the rate card    
    # Given I click "Rate Cards" button
    # When I add a new rate card named "Rate Card Test 5/April,15" effective on "4/10/2022" and expiring on "4/11/2022"
    # Then I click "Quotes" button
    # When I add a new quote named "Quote Test 5/Aprl,15" service start date as "4/11/2021" and rate card as "Rate Card Test 5/April,15"
    # Then I verify new rate card in dropdown