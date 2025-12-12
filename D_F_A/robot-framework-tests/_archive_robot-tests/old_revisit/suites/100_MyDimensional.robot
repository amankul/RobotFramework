*** Settings ***
Documentation     Verify that the My d page is loaded successfully
Metadata          Version    0.1
Suite Setup       Open My d Page
Suite Teardown    Close Browser
Test Setup
#Test Teardown     Default Test Teardown
Test Timeout      300 minutes
Library           SeleniumLibrary    timeout=10    implicit_wait=3    run_on_failure=None
Library           OperatingSystem
Library           String
Resource          browser.resource          # Contains actions related to browser activities
Resource          d.resource      # Generic objects, and keywords for all pages
Resource          Myd.resource    # Contains xpath, attributes and other resource links to artifacts on the My d page.

*** Variables ***
${numBrowseCards}           0
${filter_type}

*** Test Cases ***
Verify that the header is loaded successfully
    [Tags]    Myd    Smoke    Regression
    Run Keyword and Continue on Failure    Element should be visible    ${HEADER}          message=The Header container is not visible
    Run Keyword and Continue on Failure    Element should be visible    ${PRIVACY_POLICY}  message=The Privacy Policy container is not visible
    Run Keyword and Continue on Failure    Element should be visible    ${SEARCH_FIELD}    message=The search box element is not visible
    Run Keyword and Continue on Failure    Element should be visible    ${PROFILE}         message=The Profile button is not visible

Verify that the quick bar buttons are loaded successfully
    [Tags]    Myd    Smoke    Regression
    Run Keyword and Continue on Failure    Element should be visible    ${QUICK_BUTTON_BAR}   message=The Quick Button Bar is not visible
    Run Keyword and Continue on Failure    Element should be visible    ${WELCOME_BACK}       message=The Welcome back element is not visible
    Run Keyword and Continue on Failure    Element should be visible    ${MY_ACCOUNT}         message=The My Account element is not visible
    Run Keyword and Continue on Failure    Element should be visible    ${MY_REPORTS}         message=The My Reports element is not visible
    Run Keyword and Continue on Failure    Element should be visible    ${FIND_AN_ADVISOR}    message=Find an Advisor element is not visible
    Run Keyword and Continue on Failure    Element should be visible    ${MY_SECRETS}         message=The My Secrets element is not visible
    Run Keyword and Continue on Failure    Element should be visible    ${FAVORITES}          message=The Favorites element is not visible

A browse card is loaded successfully
    [Tags]    Smoke    Regression
    Sleep  10s

*** Keywords ***
Validate article formats
    [Tags]    Production_Only
    ${numItems}  Get number of items

    FOR  ${item}  IN RANGE  ${numItems}
        Load items  ${item}  ${numItems}  # Determine if we need to lazy load or presss <SHOW MORE> button

        # Create Xpath for the card
        ${cardId}  Calculate card locator  ${item}
        ${cardXpath}  Catenate  SEPARATOR=  //*[@id="coveo06155413"]/div[7]/div[${cardId}]/a
        ${cardObj}  Get WebElement  ${cardXpath}
        #Log  Card Xpath ${cardXpath}  DEBUG  console=yes

        ${titleObj}  Catenate  SEPARATOR=  //*[@id="coveo06155413"]/div[7]/div[${cardId}]/a/div[1]/h3
        ${title}  Get Text  ${titleObj}
        ${cardNum}  Evaluate  ${item} + 1
        Log  Article ${cardNum} ... ${title}  console=yes

        # Bug in chromedriver
        # Need to scroll to top of screen before scrolling item into view so that entire card is viewable for Click Element to work!!
        Scroll Page To Location  0  0
        Scroll element into view  ${cardXpath}
        Mouse Over  ${cardObj}
        Set Focus to Element  ${cardObj}
        ${focused}  Run Keyword and Return Status  Element Should Be Focused  ${cardObj}
        Run Keyword If  ${focused} == False  Set Focus to Element  ${cardObj}  # Try again
        Click Element  ${cardObj}
        ${articleLoaded}  Run Keyword and Return Status  Wait until element is visible  ${ARTICLE_HEADER}  5s  # Wait until the selected article is displayed
        Run keyword if  ${articleLoaded}  Run Keywords  Look for inconsistencies in article format
        ...  AND  Go Back  # Go back to previous page ... My d main page
        ...  ELSE  Log  Unable to load article  console=yes
    END

Look for inconsistencies in article format
    ${elements}  Get WebElements  .//span[@style]  # Grabs all style attributes embedded in a span element
    FOR    ${element}    IN    @{elements}  # Display all of the unexpected attributes found
        # Unexpected <span style=...><\span> found in article
        ${article}  Get Title
        ${paragraph}  Get Element Attribute  ${element}  attribute=innerHTML
        ${beginning}  Get Substring  0  30
        Log  Unexpected <span> found in ${article} for paragraph starting with ${beginning}  console=yes
    END

Verify that the browse cards are loaded successfully
    [Tags]    Myd    Smoke    Regression
    ${numBrowseCards}  Get number of items
    Run Keyword and Continue on Failure    Element should be visible        ${CLEAR}              message=The Browse section is not formatted correctly
    Run Keyword and Continue on Failure    Element should be visible        ${BROWSE_BY_SECTION}  message=The Favorites element is not visible
    Run Keyword and Continue on Failure    Element should be visible        ${BROWSE_BY}          message=The Favorites element is not visible
    Run Keyword and Continue on Failure    Element should be visible        ${BROWSE_BY_TOPIC}    message=The Browse By Topic filter element is not visible
    Run Keyword and Continue on Failure    Element should be visible        ${BROWSE_BY_FORMAT}   message=The Browse By Format filter element is not visible
    Run Keyword and Continue on Failure    Element should be visible        ${BROWSE_BY_USE}      message=The Browse By Use filter element is not visible
    Run Keyword and Continue on Failure    Element should be visible        ${CARD_DOC}           message=The card document element is not visible
    Run Keyword and Continue on Failure    Element should be visible        ${CARD_1}             message=Card 1 is not visible
    Run Keyword and Continue on Failure    Element should be visible        ${CARD_24}            message=Card 24 is not visible
    Run Keyword and Continue on Failure    Element should not be visible    ${CARD_25}            message=The Sort By element is not visible

Verify the correct number of browse cards are loaded
    [Tags]    Smoke    Regression
    ${numItems}  Get number of items
    Load all items  ${numItems}

    # Calculate xpath Id for the last browse card - taking into account the 3 extra div every 24 cards
    ${lastBrowseCardId}  Calculate card locator  ${numItems}

    # Create xpath to the last browse card
    ${lastBrowseCard}  Catenate  SEPARATOR=  //div[@id=\'coveo06155413\']/div[7]/div[${lastBrowseCardId}]/a
    Run keyword and continue on failure  Element should be visible  ${lastBrowseCard}  msg=Browse card ${lastBrowseCardId} should be present

    # Create xpath for an invalid browse card
    ${invalidBrowseCardId}  Evaluate  ${lastBrowseCardId} + 1
    ${invalidBrowseCard}  Catenate  SEPARATOR=  //div[@id=\'coveo06155413\']/div[7]/div[${invalidBrowseCardId}]/a
    Run keyword and continue on failure  Element should not be visible  ${invalidBrowseCard}  msg=Browse card ${invalidBrowseCardId} should not be present

Verify all links on the page are valid
    [Tags]    Smoke    Regression
    ${allPageLinks}  Get all links
    Log  ${allPageLinks}  console=yes
    Validate page links  ${allPageLinks}

Verify the Sort By filter selections
    [Tags]    Myd    Smoke    Regression
    Run Keyword and Continue on Failure    Element should be visible    ${SORT_BY}    message=The Sort By element is not visible
    ${current_label}    Get Text    ${SORT_BY}
    Run Keyword and Continue on Failure    Element text should be    ${SORT_BY}    ${SORT_BY_LABELS}[0]    message=The Sort By text value is not correct

    # Check that all Sort By options are as expected
    Scroll Page To Location  0  15000
    Set focus to element  ${SORT_BY}
    Click Element    ${SORT_BY}
    #Sleep  1s
    #Click Element  //html/body/div[1]/div/div[2]/div[1]/div/div[2]/section/div[1]/div[2]/div/div/ul/li[3]
    Sleep  5s

    ${labels}  Get Selected List Labels  ${SORT_BY_LIST}
    Log  ${labels}
    Run Keyword and Continue on Failure    Should be true    Evaluate    ${labels} == ${SORT_BY_LABELS}
    FOR    ${label}    IN    ${labels}
        Select from list by label    ${SORT_BY_LIST}    ${label}
        Run Keyword and Continue on Failure    Element text should be    ${SORT_BY}    ${label}    message=The Sort By text value is not correct
    END

    Select from list by label    ${SORT_BY}    ${current_label}

Verify Browse By filter types
    Scroll Page To Location  0  15000  # Scroll to show Browse By section

    # Test all of the Browse By filter types ... always run tests for all filter types
    FOR   ${browse_by_filter}    IN      @{BROWSE_BY_FILTERS}
        ${filter_type}  Get Text  ${browse_by_filter}
        Set Suite Variable  ${filter_type}
        Log  Verifying Browse By filter ... ${filter_type}  DEBUG  console=yes
        Click Element  ${browse_by_filter}
        ${filters_visible}  Run keyword and return status  Element should be visible  ${BROWSE_BY_FILTER_SECTION}
        Run Keyword If  ${filters_visible} == True  Check Filter Selections  ${browse_by_filter}
    END

Check Filter Selections
    [Arguments]  ${browse_by_filter}
    FOR  ${filter}    IN RANGE    1   99999  # No While loop so use For with VERY large loop index
        # make sure the Browse By filter type selection is still visible ... lazy loading may cause it to disappear!!
        ${filters_visible}  Run keyword and return status  Element should be visible  ${BROWSE_BY_FILTER_SECTION}
        Run Keyword If  ${filters_visible} == False  Click Element  ${browse_by_filter}

        # Calculate xpath to the next filter button
        ${filter_button}  Catenate  SEPARATOR=  //html/body/div[1]/div/div[3]/div[1]/div/div[2]/section/div[1]/div[3]/div[${filter}]/button

        # Verify that the filter button exists ... since we do not know how many buttons there are
        ${filter_visible}  Run keyword and return status  Element should be visible  ${filter_button}
        Exit For Loop If  ${filter_visible} == False  # Exhausted all filters
        Select Browse By Filter  ${filter_button}
    END

Select Browse By Filter
    [Arguments]  ${filter_button}
    ${label}  Get Text  ${filter_button}
    Log  Testing filter ... ${label}  DEBUG  console=yes
    Click Button  ${filter_button}
    Log To Console  Clicked button ${label}
    Sleep  3s  # Allow time for page to update

    Run Keyword and Continue on Failure  Wait Until Element is visible  ${SELECTED_FILTER}  timeout=5s  # Verify that selected filter is displayed
    Run Keyword and Continue on Failure  Wait Until Element is visible  ${CLEAR_ALL_FILTERS}  timeout=5s  # Verify that <Clear All> button is displayed

    # Extract number of browse cards reported by Coveo ...
    # a filter should only be displayed if at least one card contains the filter text
    ${numBrowseCards}  Get number of items
    Run keyword if  ${numBrowseCards} > 0  Load all items  ${numBrowseCards}
    Check Browse Card Format  ${numBrowseCards}  ${label}

    # *******
    # Cleanup
    # *******

    # Reset the filter
    Scroll Page To Location  0  0  # Filter MUST be visible to click!!
    Scroll Element into View  ${BROWSE_BY}
    Click Element  ${SELECTED_FILTER}

    # Verify that the selected filter and the <Clear All> button are not displayed
    # DO NOT look for buttons to disappear since the xpath section is no longer valid!!
    Run Keyword And Continue On Failure  Element should be visible  ${BROWSE_BY_FILTER_CLEAR}

Check Browse Card Format
    [Arguments]  ${numBrowseCards}  ${filter_label}
    FOR  ${browseCard}    IN RANGE    ${numBrowseCards}
        ${cardId}  Calculate card locator  ${browseCard}
        ${cardLocator}  Catenate  SEPARATOR=  //*[@id="coveo06155413"]/div[7]/div[${cardId}]/a/div[1]/p[1]  # With topic
        ${altLocator}  Catenate  //*[@id="coveo06155413"]/div[7]/div[${cardId}]/a/div[1]/p  # Without topic
        Log  Card number ${browseCard + 1} with xpath of ${cardLocator}  DEBUG  console=yes

        # Verify the card displays the selected filter
        Run Keyword and Continue on Failure  Element should be visible  ${cardLocator}
        Run keyword if  '${filter_type}' == 'topic'
        ...  Run Keyword and Continue on Failure  Element text should be  ${cardLocator}  ${filter_label}
        ...  ELSE IF  '${filter_type}' == 'format' and '${filter_label}' != 'OTHER RESOURCES'
        ...     Check Browse Card header  ${cardLocator}  ${altLocator}  ${filter_label}
        ...  ELSE IF  '${filter_type}' == 'use'
        ...     Check Browse Card header  ${cardLocator}  ${altLocator}  ${filter_label}
        ...  ELSE IF  '${filter_type}' == 'format' and '${filter_label}' == 'OTHER RESOURCES'
        ...     No Operation  # Skip verifying Other Resources - for now
        ...  ELSE
        ...     FAIL  msg=Illegal filter type ${filter_type} with selection ${filter_label}
    END

Check Browse Card header
    [Arguments]  ${cardLocator}  ${altLocator}  ${filter_label}
    ${validLocator}  Run keyword and return status  Element text should be  ${cardLocator}  ${filter_label}  # Try card that displays topic
    Run Keyword If  ${validLocator} == False
    ...  Run Keyword and Continue on Failure  Element text should be  ${altLocator}  ${filter_label}

Calculate card locator
    [Arguments]  ${cardNum}
    # Calculate xpath Id - taking into account the 3 extra div every 24 cards
    ${cardLocator}  Evaluate  (${cardNum} + (math.floor(${cardNum} / ${NUM_CARDS_TO_LOAD}) * 3)) + 1  math

    [Return]  ${cardLocator}
