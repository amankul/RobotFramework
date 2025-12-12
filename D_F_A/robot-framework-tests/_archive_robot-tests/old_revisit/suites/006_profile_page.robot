*** Settings ***
Documentation     A test suite containing tests related to verifying and changing Profile preferences.
Metadata          Version       0.1
Metadata          Test Case     AAI-T448
Metadata          Test Case     AAI-T445
Metadata          Test Case     AAI-T454
Metadata          Test Case     AAI-T457
Metadata          Test Case     AAI-T458
Metadata          Test Case     AAI-T459
Metadata          Test Case     AAI-T463
Metadata          Test Case     AAI-T475
Metadata          Test Case     AAI-T476
Default Tags      CARPO     Smoke    Regression
Suite Setup       Open My d Page
Suite Teardown    Close Browser
Test Setup        Access The Profile Page
Test Teardown     Logout User
Library           OperatingSystem
Library           String
Library           DateTime
Library           SeleniumLibrary    timeout=10    implicit_wait=3    run_on_failure=None
Resource          d.resource      # Generic objects, and keywords for all pages
Resource          Myd.resource    # Contains xpath, attributes and other resource links to artifacts on the My d page.
Resource          login.resource            # Contains xpath, attributes and other resources necessary for logging in to web site
Resource          browser.resource          # Contains attributes and other resources necessary for logging in to web site

*** Variables ***
${ORIGINAL_ACCOUNT_NAME}            Saltheart Foamfollower
${CURRENT EMAIL}                    ${VALID USER}
${CURRENT NAME}                     ${ORIGINAL_ACCOUNT_NAME}
${CURRENT PASSWORD}                 ${VALID PASSWORD}
${CURRENT USER}                     ${VALID USER}
${DUPLICATE_EMAIL_ADDRESS}          dddx+Hawkeye.Pierce@gmail.com
${NAME_CHANGE_SUBMITTED}            Name Change Submitted
${NEW_ACCOUNT_NAME}                 Ernest Borgnine
${NEW_EMAIL_ADDRESS}                dddx+Ernest.Borgnine@gmail.com
${NEW_PASSWORD}                     Land$hark7
${NEW_SECURITY_ANSWER}              Snoopy
${NEW_TEXT_NUMBER}                  512-www-zzzz
${ORIGINAL_SECURITY_ANSWER}         ${SECURITY QUESTION ANSWER}
${ORIGINAL_TEXT_NUMBER}             512-262-9362

*** Test Cases ***
# ****************************************************************************
# These test cases are used to verify the elements on the Account Settings tab
# ****************************************************************************
The Password Can Be Changed
    [Tags]  AAI-T457
    # ****************************************
    # Text Verification is NOT yet supported!!
    #
    # Use Security Question Verification ONLY!!
    # *****************************************
    Log  Password change will ONLY be done using security question to verify account  console=yes

    ${last reset}=  Get Text  ${PROFILE_PASSWORD_RESET_DATE}
    Change the Password Using Text Verification  ${NEW_EMAIL_ADDRESS}
    Click Element  ${DIALOG_CHANGE_EMAIL_CANCEL}
    The Email Address Should Be  ${VALID USER}
    Element Text Should Be  ${PROFILE_PASSWORD_RESET_DATE}  ${last reset}  # Check that Last reset date has not changed!!

    Click Button  ${DIALOG_CHANGE_PASSWORD_USE_SECURITY_BTTN}

    Click Button  ${DIALOG_CHANGE_EMAIL_CANCEL_BTTN}
    The Email Address Should Be  ${VALID USER}
    Element Text Should Be  ${PROFILE_PASSWORD_RESET_DATE}  ${last reset}  # Check that Last reset date has not changed!!

    Click Button  ${DIALOG_CHANGE_PASSWORD_USE_SECURITY_BTTN}
    The Answer To The Security Question Should Be  ${ORIGINAL_SECURITY_ANSWER}

The Name On The Account Can Be Changed
    [Tags]  AAI-T445
    Log  ${SPACE}${SPACE} Validating Cancel functionality ... Using Cancel Button  console=yes
    Change the Account Name  ${NEW_ACCOUNT_NAME}
    Click Button  ${DIALOG_CHANGE_NAME_CANCEL_BTTN}
    The Name on the Account Should Be  ${ORIGINAL_ACCOUNT_NAME}

    Log  ${SPACE}${SPACE} Validating Cancel functionality ... Using Dialog Close X Button  console=yes
    Change the Account Name  ${NEW_ACCOUNT_NAME}
    Click Element  ${DIALOG_CHANGE_NAME_CANCEL}
    The Name on the Account Should Be  ${ORIGINAL_ACCOUNT_NAME}

    Log  ${SPACE}${SPACE} Validating changing username  console=yes
    Change the Account Name  ${NEW_ACCOUNT_NAME}
    Click Button  ${DIALOG_CHANGE_NAME_FINISH_BTTN}
    Set Suite Variable  ${CURRENT USER}  ${NEW_ACCOUNT_NAME}
    Wait For Name Change To Be Processed
    The Name on the Account Should Be  ${NEW_ACCOUNT_NAME}

    # ***** Reset the name on the account back to its initial value *****
    Log  ${SPACE}${SPACE} Resetting username to original value  console=yes
    Change the Account Name  ${ORIGINAL_ACCOUNT_NAME}
    Click Button  ${DIALOG_CHANGE_NAME_FINISH_BTTN}
    Set Suite Variable  ${CURRENT USER}  ${ORIGINAL_ACCOUNT_NAME}
    Wait For Name Change To Be Processed
    The Name on the Account Should Be  ${ORIGINAL_ACCOUNT_NAME}

Validate Email Address Formats
    [Template]  Testing ${test type} for Email Address ${email address} Should Be ${expected}
    [Tags]  AAI-T475  AAI-T476
    Invalid email - Trailing hyphen                 abc-@mail.com                          invalid
    Invalid email - 2 dots                          abc..def@mail.com                      invalid
    Invalid email - Leading dot                     .abc@mail.com                          invalid
    Invalid email - Illegal char                    abc#def@mail.com                       invalid
    Invalid email - Exceeds 64 char                 abc#def@mail.com                       invalid
    Valid email - Max 64 char                       abc#def@mail.com                       valid
    Valid email - Dash                              abc-d@mail.com                         valid
    Valid email - Dot                               abc.def@mail.com                       valid
    Valid email                                     abc@mail.com                           valid
    Valid email - Underscore                        abc_def@mail.com                       valid
    Valid email - Trailing number                   abc_def1@mail.com                      valid
    Valid email - Leading number                    1abc_def@mail.com                      valid
    Invalid email domain - Illegal char             abc.def@mail#archive.com               invalid
    Invalid email domain - Missing domain chars     abc.def@mail                           invalid
    Invalid email domain - Single domain char       abc.def@mail.c                         invalid
    Invalid email domain - Multiple periods         abc.def@mail..com                      invalid
    Invalid email domain - Multiple @@              abc.def@@mail.com                      invalid
    Invalid email domain - Trailing hyphen          username@example-.com                  invalid
    Invalid email domain - Leading hyphen           username@-example.com                  invalid
    Invalid email domain - Consecutive hyphens      username@ex--ample.com                 invalid
    Valid email domain 1                            abc.def@mail.cc                        valid
    Valid email domain 2                            abc.def@mail-archive.com               valid
    Valid email domain 3                            abc.def@mail.org                       valid
    Valid email domain 4                            abc.def@mail.com                       valid
    Valid email domain 5                            john@server.department.company.com     valid
    Valid email domain 6                            abc.def@mail1.com                      valid
    Valid email domain 7                            abc.def@1mail.com                      valid

The Email Address Can Be Changed
    [Tags]  AAI-T454  AAI-T448
    Log  ${SPACE}${SPACE} Validating Cancel functionality ... Using Cancel Button  console=yes
    Change the Email Address  ${NEW_EMAIL_ADDRESS}
    Click Button  ${DIALOG_CHANGE_EMAIL_CANCEL_BTTN}
    The Email Address Should Be  ${VALID USER}

    Log  ${SPACE}${SPACE} Validating Cancel functionality ... Using Dialog Close X Button  console=yes
    Change the Email Address  ${NEW_EMAIL_ADDRESS}
    Click Element  ${DIALOG_CHANGE_EMAIL_CANCEL}
    The Email Address Should Be  ${VALID USER}

    Log  ${SPACE}${SPACE} Validating handling of duplicate email address  console=yes
    Change the Email Address  ${DUPLICATE_EMAIL_ADDRESS}
    Click Button  ${DIALOG_CHANGE_EMAIL_SUBMIT_BTTN}
    The Email Address Should Be  ${VALID USER}

    # **********************************************************
    # ON HOLD - NEED TO VERIFY IT REQUIRES NO USER INPUT IN CRM!
    # **********************************************************
    #Log  ${SPACE}${SPACE} Validating Duplicate Email Address  console=yes
    #Change the Email Address  ${DUPLICATE_EMAIL_ADDRESS}
    #Click Button  ${DIALOG_CHANGE_EMAIL_SUBMIT_BTTN}
    #The Email Address Should Be  ${VALID USER}

    # **********************************************************
    # ON HOLD - UNTIL CRM ENTRY CAN BE CONFIRMED USING CRM API!!
    # **********************************************************
    #Log  ${SPACE}${SPACE} Validating changing Email Address  console=yes
    #Change the Email Address  ${NEW_EMAIL_ADDRESS}
    #Click Button  ${DIALOG_CHANGE_EMAIL_SUBMIT_BTTN}
    #The Email Address Should Be  ${NEW_EMAIL_ADDRESS}

    # Reset the name on the account back to its initial value
    #Log  ${SPACE}${SPACE} Resetting Email Address to original value  console=yes
    #Change the Email Address  ${VALID USER}
    #Click Button  ${DIALOG_CHANGE_EMAIL_SUBMIT_BTTN}
    #The Email Address Should Be  ${VALID USER}

The Password Change Is Denied
    [Tags]  AAI-T457
    No Operation

The Security Question Can Be Changed
    [Tags]  AAI-T458
    Log  REQUIRES Text Verification which is NOT yet supported!!  console=yes

The Phone Verification Number Can Be Changed
    [Tags]  AAI-T459
    No Operation

# ***********************************************************************
# These test cases are used to verify the elements on the Preferences tab
# ***********************************************************************
Country Can Be Changed
    [Tags]  AAI-T463
    No Operation

*** Keywords ***
Access The Profile Page
    Log In As External Client  ${CURRENT USER}  ${CURRENT PASSWORD}
    Display Profile Page

Display Profile Page
    [Documentation]  This keyword displays the Profile page and verifies that all of the fields are visible and present.
    ...  It does NOT verify the content of any of the elements.
    Click Element  ${USER_PROFILE}
    Click Element  ${PROFILE_PROFILE}
    Wait Until Element is Visible  ${PAGE_PROFILE}  15s

    # Verify the elements of the Personal Information tab
    Element Text Should Be  ${PROFILE_PERSONAL_INFO_HEADING}  Personal Information
    Element Text Should Be  ${PROFILE_NAME_LABEL}  NAME
    Element Should Be Visible  ${PROFILE_NAME_CHANGE}

    Element Text Should Be  ${PROFILE_EMAIL_ADDRESS_LABEL}  EMAIL ADDRESS
    Element Should Be Visible  ${PROFILE_EMAIL_ADDRESS_CHANGE}

    Element Text Should Be  ${PROFILE_SECURITY_HEADING}  Security

    Element Text Should Be  ${PROFILE_PASSWORD_LABEL}  PASSWORD
    Element Should Be Visible  ${PROFILE_PASSWORD_CHANGE_BTTN}

    Element Text Should Be  ${PROFILE_SECURITY_QUESTION_LABEL}  SECURITY QUESTION
    Element Should Be Visible  ${PROFILE_SECURITY_QUESTION_CHANGE}
    Element Should Be Visible  ${PROFILE_SECURITY_QUESTION_RESET_DATE}

    Element Text Should Be  ${PROFILE_PHONE_VERIFICATION_LABEL}  PHONE VERIFICATION
    Element Should Be Visible  ${PROFILE_PHONE_VERIFICATION_CHANGE}

    # Verify the elements of the Preferences tab
    Click Element  ${PROFILE_PREFERENCES_TAB}

    Element Text Should Be  ${PROFILE_PREFERENCES_NOTIFICATIONS}  Notifications
    ${WeeklyDigest}=  Get Element Count  ${PROFILE_PREFERENCES_WEEKLY_DIGEST}
    Run Keyword and Continue on Failure  Run Keyword If  ${WeeklyDigest} < 1  Fail  Weekly Digest is NOT present
    Element Text Should Be  ${PROFILE_CONTENT_PREFERENCES_LABEL}  Content View
    Element Text Should Be  ${PROFILE_COUNTRY_LABEL}  COUNTRY
    Element Should Be Visible  ${PROFILE_COUNTRY_CHANGE}
    Element Should Be Visible  ${PROFILE_COUNTRY}
    ${selected_country}=  Run Keyword If  ${WeeklyDigest} == 1  Get Text  ${PROFILE_COUNTRY}
    ...  ELSE  Get Text  ${PROFILE_COUNTRY_NO_NOTIFICATIONS}
    Run Keyword If  '${selected_country}' == 'United States'  Run Keywords  Element Text Should Be  ${PROFILE_FEATURED_CONTENT_LABEL}  CONTENT VIEW
    ...  AND  Element Should Be Visible  ${PROFILE_FEATURED_CONTENT_FA}
    ...  AND  Element Should Be Visible  ${PROFILE_FEATURED_CONTENT_BOTH}
    ...  AND  Element Should Be Visible  ${PROFILE_FEATURED_CONTENT_INSTITUTIONAL}
    ...  ELSE  Run Keywords  Should Not Be Visible  ${PROFILE_FEATURED_CONTENT_LABEL}
    ...  AND  Element Should Not Be Visible  ${PROFILE_FEATURED_CONTENT_FA}
    ...  AND  Element Should Not Be Visible  ${PROFILE_FEATURED_CONTENT_BOTH}
    ...  AND  Element Should Not Be Visible  ${PROFILE_FEATURED_CONTENT_INSTITUTIONAL}

    # Verify elements on the Internal tab
    # TBD based on limitations of the Docker container being on d network

    Click Element  ${PROFILE_ACCOUNT_SETTINGS_TAB}

Verify Your Identity
    Wait Until Element is Visible  ${VERIFY_IDENTITY_DIALOG}
    Click Element  ${VERIFY_IDENTITY_SECURITY_QUESTION}

Change the Account Name
    [Arguments]    ${name}
    Click Element  ${PROFILE_NAME_CHANGE}

    Wait Until Element is Visible  ${DIALOG_CHANGE_NAME}
    Element Should Be Enabled  ${DIALOG_CHANGE_NAME_CANCEL_BTTN}
    ${attr}=  Get Element Attribute  ${DIALOG_CHANGE_NAME_FINISH_BTTN}  class
    #Log  Finish button attributes: ${attr}  console=yes
    Should Contain  ${attr}  button-action-disabled  # Finish button is disabled

    # Verify First and Last Name
    @{names}=  Split String  ${CURRENT NAME}  ${SPACE}
    ${first name}=  Get Value  ${DIALOG_CHANGE_NAME_FIRST}
    Should Be Equal  @{names}[0]  ${first name}
    ${last name}=  Get Value  ${DIALOG_CHANGE_NAME_LAST}
    Should Be Equal  @{names}[1]  ${last name}

    # Change First name
    @{names}=  Split String  ${name}  ${SPACE}
    Clear Element Text  ${DIALOG_CHANGE_NAME_FIRST}
    Input Text    ${DIALOG_CHANGE_NAME_FIRST}    @{names}[0]
    ${attr}=  Get Element Attribute  ${DIALOG_CHANGE_NAME_FINISH_BTTN}  class
    #Log  Finish button attributes: ${attr}  console=yes
    Should Not Contain  ${attr}  button-action-disabled  # Finish button is enabled

    # Change Last name
    Clear Element Text  ${DIALOG_CHANGE_NAME_LAST}
    Input Text    ${DIALOG_CHANGE_NAME_LAST}    @{names}[1]
    ${attr}=  Get Element Attribute  ${DIALOG_CHANGE_NAME_FINISH_BTTN}  class
    #Log  Finish button attributes: ${attr}  console=yes
    Should Not Contain  ${attr}  button-action-disabled  # Finish button is enabled

The Name on the Account Should Be
    [Arguments]  ${expected name}
    Element Text Should Be  ${PROFILE_NAME}  ${expected name}

Wait For Name Change To Be Processed
    Wait Until Element Contains  ${DIALOG_NAME_CHANGE_SUBMITTED_LABEL}  ${NAME_CHANGE_SUBMITTED}
    Click Button  ${DIALOG_NAME_CHANGE_SUBMITTED_BACK_BTTN}
    Log Out
    Sleep  20m
    Access The Profile Page

Testing ${test type} for Email Address ${email address} Should Be ${expected}
    Log  Testing ... ${test type}  console=yes
    Input Text  ${DIALOG_CHANGE_EMAIL_NEW}  ${email address}
    Press Keys  ${DIALOG_CHANGE_EMAIL_NEW}    TAB  # Tab to Password to allow for pre-check on Username
    Run Keyword if  '${expected}' == 'valid'  Run Keyword and Continue on Failure    Email Address Should Be Valid
    ...  ELSE  Run Keyword and Continue on Failure    Email Address Should Have Failed
    Clear Element Text  ${DIALOG_CHANGE_EMAIL_NEW}

Email Address Should Have Failed
    Element Text Should Be  ${DIALOG_CHANGE_EMAIL_NEW_INVALID}  ${NEW_EMAIL_IS_INVALID}

Email Address Should Be Valid
    Element Text Should Not Be  ${DIALOG_CHANGE_EMAIL_NEW_INVALID}  ${NEW_EMAIL_IS_INVALID}

Change the Email Address
    [Arguments]    ${email}
    Click Element  ${PROFILE_EMAIL_ADDRESS_CHANGE}

    Wait Until Element is Visible  ${DIALOG_CHANGE_EMAIL}

    Clear Element Text  ${DIALOG_CHANGE_EMAIL_NEW}
    Input Text    ${email}

    Clear Element Text  ${DIALOG_CHANGE_EMAIL_CONFIRM}
    Input Text    ${email}

The Email Address Should Be
    [Arguments]  ${expected email}
    Element Text Should Be  ${PROFILE_EMAIL_ADDRESS}  ${expected email}

Change the Password Using Security Question
    [Arguments]  ${password}
    Click Button  ${PROFILE_PASSWORD_CHANGE_BTTN}
    Click Button  ${VERIFY_IDENTITY_SECURITY_QUESTION}
    Change The Password  ${password}

Change the Password Using Text Verification
    [Arguments]  ${password}
    Click Button  ${PROFILE_PASSWORD_CHANGE_BTTN}
    Change The Password  ${password}

Change The Password
    Wait Until Element is Visible  ${DIALOG_CHANGE_PASSWORD}

    Rejects passwords that omit required character types
    Rejects passwords with bad lengths
    Rejects passwords that contain illegal phrases
    Accepts minimum and maximum length passwords

The Password Should Be
    No Operation

The Answer To The Security Question Should Be
    No Operation

The Phone Verification Type Should Be
    No Operation

The Phone Verification Number Should Be
    No Operation

The Country Should Be
    No Operation
