*** Settings ***
Documentation   Variables and tests that are common to all test cases and suites
Library         OperatingSystem
Library         String
Resource        login.resource  # Contains attributes and other resources necessary for logging in to web site 

*** Variables ***
# ************
# Test Objects
# ************

# *********
# Constants
# *********
${MAX_CARDS_TO_LAZY_LOAD}           48
${NUM_CARDS_TO_LOAD}                24

# ****************
# Global Variables
# ****************

*** Keywords ***
Click Article
    [Arguments]    ${xpath}
    Actions actions = new Actions(driver);
    Execute JavaScript    actions.moveToElement(driver.findElement(By.xpath("//a[text()='Audio']"))).click().build().perform();

Get number of items
    Run Keyword and Continue on Failure    Element should be visible    ${NUM_ITEMS}    message=Number of item element is not visible
    ${num_cards}    Get Text    ${NUM_ITEMS}
    ${match}    Get Regexp Matches    ${num_cards}    (\\d+)\\s+items    1
    ${numItems}    Set variable    ${match[0]}
    Log    Number of items is ${numItems}  DEBUG  console=yes

    [Return]  ${numItems}

Load items
    [Arguments]  ${item}  ${numItems}
    # Need to determine if we need to lazy load or presss <SHOW MORE> button
    ${lazyLoadState}  Evaluate  ${NUM_CARDS_TO_LOAD} <= ${item} < ${MAX_CARDS_TO_LAZY_LOAD}  
    ${numberOfItemsLoaded}  Run keyword if  ${item} < ${NUM_CARDS_TO_LOAD}  No Operation
    ...  ELSE IF  ${lazyLoadState}  Lazy load items  ${numItems}
    ...  ELSE  Load all items  ${numItems}
        
Load all items
    [Arguments]  ${numItemsToLoad}
    Lazy load items  ${numItemsToLoad}  
    FOR  ${i}  IN RANGE  99999  # No While so use For with a VERY large index
        ${visible}  Run keyword and return status  Element should be visible  ${SHOW_MORE_BTTN}
        Exit For Loop If  ${visible} == False
        Click button  ${SHOW_MORE_BTTN}
        #Run keyword and ignore error  Wait until element is visible  ${SHOW_MORE_BTTN}  timeout=5s
    END

Lazy load items
    [Arguments]  ${numItemsToLoad}
    ${numItemsLoaded}  Set Variable  ${NUM_CARDS_TO_LOAD}
    ${scrollPosition}  Set Variable  0

    # Scroll screen until the <Show More> button is displayed
    FOR  ${i}  IN RANGE  99999  # No While loop so use For with VERY large loop index
        ${scrollPosition}  Evaluate  ${scrollPosition} + 15000
        Scroll Page To Location  0  ${scrollPosition}
        Sleep  2s  # Allow time for page to update
        ${numItemsLoaded}  Evaluate  ${numItemsLoaded} + ${NUM_CARDS_TO_LOAD}
        Exit For Loop If  ${numItemsLoaded} >= ${numItemsToLoad}
        ${buttonVisible}  Run Keyword and Return Status  Scroll element into view  ${SHOW_MORE_BTTN}
        Exit For Loop If  ${buttonVisible}
    END

Validate page links
    [Arguments]  ${links}
    No Operation