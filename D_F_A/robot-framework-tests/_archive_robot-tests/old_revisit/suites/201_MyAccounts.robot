*** Settings ***
Documentation     A test suite containing tests related to login functionality.
Metadata          Version       1.0
Metadata          Test Case     AAI-T231
Metadata          Test Case     AAI-T684
Default Tags      MAMR  MyAccounts
Suite Setup       Open My d Page
Suite Teardown    Close Browser
Test Setup
Test Teardown     Reload Page
Library           SeleniumLibrary    timeout=10    implicit_wait=3    run_on_failure=None
Resource          d.resource      # Generic objects, and keywords for all pages
Resource          Myd.resource    # Contains xpath, attributes and other resource links to artifacts on the My d page.
Resource          login.resource            # Contains xpath, attributes and other resources necessary for logging in to web site
Resource          browser.resource          # Contains attributes and other resources necessary for launching the web site

*** Variables ***

*** Test Cases ***
Validate MyAccount Page Loads Correctly
    [Tags]  Smoke  Production  Positive
    [Documentation]   A test that verifies all of the fields are displayed on the MyAccounts page.
    # Click My Account
    # Wait until page is displayed
    # Verify My Account tab is visible and has focus
    # Verify My Reports tab is visible and does not have focus
    # Verify 'Client Directory' text is visible
    # Verify Dynamic Client Count is visible and shows 84 accounts (used to verify backend)
    # Verify As of text in header is visible
    # Verify Dynamic as of date is visible
    # Verify Date defaults to the previous business day or the previous business day preceding the holiday.
    # Verify EXPAND ALL text is visible and is a clickable
    # Verify TOTAL ASSETS text is visible
    # Verify For each client displayed the downward charat is visible
    # Verify Client Names are visible
    # Verify 0 accounts selected is visible
    # Verify View Transcations is visible, but greyed out
    # Verify Download is visible and is clickable

*** Keywords ***
Username Should Have Failed
    Login Page Should Be Open
    Element Should Be Visible  ${LOGIN_USERNAME_REQUIRED}
    Element Text Should Be  ${LOGIN_USERNAME_REQUIRED}  ${MSG_INVALID_USERNAME}

Username Should Be Valid
    Login Page Should Be Open
    Element Text Should Be  ${LOGIN_USERNAME_REQUIRED}  ${MSG_VALID_USERNAME}

Return to Login Page
    Logout User
    Wait Until Element is Visible  ${LOGIN_USERNAME}
    Login Page Should Be Open
    ${username}=  Get Value  ${LOGIN_USERNAME}
    Should Be Equal  ${username}  ${VALID USER}
    Checkbox Should Be Selected  ${LOGIN_REMEMBER_ME}