*** Settings ***
Documentation     A test suite for validating the Shadforth user access.
Metadata          Version       1.0
Metadata          Test Case     AAI-T703
Default Tags      CARPO  Shadforth
Suite Setup       Open My d Page
Suite Teardown    Close Browser
Test Setup
Test Teardown     Logout User
Test Template     Validate Shadforth Access
Library           SeleniumLibrary    timeout=10    implicit_wait=3    run_on_failure=None
Resource          d.resource      # Generic objects, and keywords for all pages
Resource          Myd.resource    # Contains xpath, attributes and other resource links to artifacts on the My d page.
Resource          login.resource            # Contains xpath, attributes and other resources necessary for logging in to web site
Resource          browser.resource          # Contains attributes and other resources necessary for logging in to web site

*** Variables ***
&{COUNTRIES}  Australia=AU  New Zealand=NZ  Canada=CA  Germany=GE  Hong Kong=HK  Ireland=IR  Netherlands=NL  Singapore=SG  Switzerland=CH  United Kingdom=UK  United States=US
@{SHADFORTH ARTICLES}  Mosaic Monthly Report (SFIT)  Mosaic Monthly Report (SACE)  Mosaic Quarterly Snapshot (SICE)  Mosaic Fund Profile (SICE)  Strategic Funds Quarterly Update  Mosaic Monthly Report (SGRE)  Mosaic Monthly Report (SICE)  Mosaic Fund Profile (SGRE)  Mosaic Quarterly Snapshot (SACE)  Mosaic Quarterly Snapshot_SFIT  Mosaic Fund Profile (SACE)  Mosaic Fund Profile (SFIT)  Mosaic Funds Year in Review - 2018/19

*** Test Cases ***                          USER TYPE               COUNTRY                 RESULT
Validate User has Shadforth Access
    [Template]  Testing ${scheme} with ${user_type} in ${country} Should Pass
    [Tags]  Smoke  Positive  Production  AAI-T703
    [Documentation]
    Shadforth User in Australia                 Shadforth               Australia
    Shadforth User in New Zealand               Shadforth               New Zealand
    Internal User in Australia                  Internal                Australia
    Internal User in New Zealand                Internal                New Zealand

Validate User does not have Shadforth Access
    [Template]  Testing ${scheme} with ${user_type} in ${country} Should Fail
    [Tags]  Regression  Negative  AAI-T703
    [Documentation]
    Shadforth User in Canada                    Shadforth               Canada
    Shadforth User in Germany                   Shadforth               Germany
    Shadforth User in Hong Kong                 Shadforth               Hong Kong
    Shadforth User in Ireland                   Shadforth               Ireland
    Shadforth User in Netherlands               Shadforth               Netherlands
    Shadforth User in Singapore                 Shadforth               Singapore
    Shadforth User in Switzerland               Shadforth               Switzerland
    Shadforth User in United Kingdom            Shadforth               United Kingdom
    Shadforth User in United States             Shadforth               United States
    Non-Shadforth User in Australia             Non-Shadforth           Australia
    Non-Shadforth User in New Zealand           Non-Shadforth           New Zealand
    Non-Shadforth User in Canada                Non-Shadforth           Canada
    Non-Shadforth User in Germany               Non-Shadforth           Germany
    Non-Shadforth User in Hong Kong             Non-Shadforth           Hong Kong
    Non-Shadforth User in Ireland               Non-Shadforth           Ireland
    Non-Shadforth User in Netherlands           Non-Shadforth           Netherlands
    Non-Shadforth User in Singapore             Non-Shadforth           Singapore
    Non-Shadforth User in Switzerland           Non-Shadforth           Switzerland
    Non-Shadforth User in United Kingdom        Non-Shadforth           United Kingdom
    Non-Shadforth User in United States         Non-Shadforth           United States
    Internal User in Canada                     Internal                Canada
    Internal User in Germany                    Internal                Germany
    Internal User in Hong Kong                  Internal                Hong Kong
    Internal User in Ireland                    Internal                Ireland
    Internal User in Netherlands                Internal                Netherlands
    Internal User in Singapore                  Internal                Singapore
    Internal User in Switzerland                Internal                Switzerland
    Internal User in United Kingdom             Internal                United Kingdom
    Internal User in United States              Internal                United States

*** Keywords ***
Testing ${scheme} with ${user_type} in ${country} Should Pass
    Run Keyword if  '${user_type}' == 'Shadforth'  Log In As External Client  ${SHADFORTH USER}  ${SHADFORTH PASSWORD}
    ...  ELSE IF  '${user_type}' == 'Non-Shadforth'  Log In As External Client  ${VALID USER}  ${VALID PASSWORD}
    ...  ELSE IF  '${user_type}' == 'Internal'  Log In As d Employee
    ...  ELSE  Log  Invalid User Type declared  console=yes

    # Change Country code
    ${initial_country}=  Change Country Code  ${country}

    # Validate articles
    FOR  ${item}  IN  @{SHADFORTH ARTICLES}
        #Log  Accessing article ${item}  console=yes
        # Search for article ... put item in "" so that it looks for entire string and not individual words
        ${article}=  Catenate  SEPARATOR=  \"  ${item}  \"
        Clear Element Text  ${SEARCH_FIELD}
        Input Text    ${SEARCH_FIELD}    ${article}\n

        Document Should Be Found  ${article}
    END

    Clear Element Text  ${SEARCH_FIELD}

    # Change Country code back to original value
    Change Country Code  ${initial_country}

Testing ${scheme} with ${user_type} in ${country} Should Fail
    Run Keyword if  '${user_type}' == 'Shadforth'  Log In As External Client  ${SHADFORTH USER}  ${SHADFORTH PASSWORD}
    ...  ELSE IF  '${user_type}' == 'Non-Shadforth'  Log In As External Client  ${VALID USER}  ${VALID PASSWORD}
    ...  ELSE IF  '${user_type}' == 'Internal'  Log In As d Employee
    ...  ELSE  Log  Invalid User Type declared  console=yes

    # Change Country code
    ${initial_country}=  Change Country Code  ${country}

    # Validate articles
    FOR  ${item}  IN  @{SHADFORTH ARTICLES}
        #Log  Accessing article ${item}  console=yes
        # Search for article ... put item in "" so that it looks for entire string and not individual words
        ${article}=  Catenate  SEPARATOR=  \"  ${item}  \"
        Clear Element Text  ${SEARCH_FIELD}
        Input Text    ${SEARCH_FIELD}    ${article}\n

        Document Should Not Be Found  ${article}
    END

    Clear Element Text  ${SEARCH_FIELD}

    # Change Country code back to original value
    Change Country Code  ${initial_country}

Change Country Code
    [Arguments]  ${country}
    # Go to Prefences Tab on Profile Page
    Click Element  ${USER_PROFILE}
    Click Element  ${PROFILE_PROFILE}
    Wait Until Element is Visible  ${PAGE_PROFILE}  15s
    ${focus}=  Run Keyword and Return Status  Element Should Be Focused  ${PROFILE_PREFERENCES_TAB}
    Run Keyword Unless  ${focus}  Click Element  ${PROFILE_PREFERENCES_TAB}  # ONLY Click if Preferences Tab does not have focus

    # Determine if there is a Weekly Digest for the selected country
    ${WeeklyDigest}=  Run Keyword and Continue On Failure  Get Element Count  ${PROFILE_PREFERENCES_WEEKLY_DIGEST}
    ${initial_country}=  Run Keyword If  ${WeeklyDigest} == 1  Get Text  ${PROFILE_COUNTRY}
    ...  ELSE  Get Text  ${PROFILE_COUNTRY_NO_NOTIFICATIONS}

    Run Keyword If  ${WeeklyDigest} == 1  Click Element  ${PROFILE_COUNTRY_CHANGE}
    ...  ELSE  Click Element  ${PROFILE_COUNTRY_CHANGE_NO_NOTIFICATIONS}

    Sleep  1s  # Having trouble finding if React Modal Dialog is displayed so add a small wait to allow page to be displayed

    Click Element  css=div.dfa-dropdown-init.dfa-dropdown-init-false > svg.image-arrow

    Click Element  //button/span/span[contains(text(),'${country}')]

    # Click the Accept button
    Click Element  xpath=(.//*[normalize-space(text()) and normalize-space(.)='Terms of Use'])[2]/following::button[1]

    # Wait until country change is processed ... this could take 10-15 seconds
    Wait Until element is Visible  //html/body/div[9]/div/div/div/div/div/a  timeout=20s
    Click Element  //html/body/div[9]/div/div/div/div/div/a  # Return to Profile page
    Sleep  15s  # Fixes race condition but need better approach!!

    # Wait until the country has been updated on the web page
    ${WeeklyDigest}=  Run Keyword and Continue On Failure  Get Element Count  ${PROFILE_PREFERENCES_WEEKLY_DIGEST}
    Run Keyword If  ${WeeklyDigest} == 1  Wait Until Element Contains  ${PROFILE_COUNTRY}  ${country}  error=Country NOT updated on page
    ...  ELSE  Wait Until Element Contains  ${PROFILE_COUNTRY_NO_NOTIFICATIONS}  ${country}  error=Country NOT updated on page

    [Return]  ${initial_country}

Document Should Be Found
    [Arguments]  ${article}
    ${search_string}=  Catenate  SEPARATOR=  Showing 1 results for  ${SPACE}  \"  ${article}  \"
    Run Keyword and Continue On Failure  Wait Until Element Contains  ${SEARCH_RESULTS}  ${search_string}

Document Should Not Be Found
    [Arguments]  ${article}
    ${search_string}=  Catenate  SEPARATOR=  Showing 0 results for  ${SPACE}  \"  ${article}  \"
    Run Keyword and Continue On Failure  Wait Until Element Contains  ${SEARCH_RESULTS}  ${search_string}
