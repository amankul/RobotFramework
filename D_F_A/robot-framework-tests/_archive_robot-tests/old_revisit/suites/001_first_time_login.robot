*** Settings ***
Documentation     A test suite containing tests related to First Time Login (FTL).
Metadata          Version       0.1
Default Tags      CARPO     Smoke    Regression
Suite Setup       Open My d Page
Suite Teardown    Close Browser
Test Teardown     Reload Page
Library           SeleniumLibrary    timeout=10    implicit_wait=3    run_on_failure=None
Resource          d.resource      # Generic objects, and keywords for all pages
Resource          Myd.resource    # Contains xpath, attributes and other resource links to artifacts on the My d page.
Resource          login.resource            # Contains attributes and other resources necessary for logging in to web site

*** Variables ***

*** Test Cases ***

*** Keywords ***
Status Should Be ${required_status}
    ${status}  Get Text status
    Should Be Equal  ${required_status}  ${status}