*** Settings ***
Documentation     A test suite containing tests related to login functionality.
Metadata          Version       1.0
Metadata          Test Case     AAI-T231
Metadata          Test Case     AAI-T684
Default Tags      MAMR
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
Validate User Does Not Have MAMR Access
    [Tags]  Smoke
    Pass Execution

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