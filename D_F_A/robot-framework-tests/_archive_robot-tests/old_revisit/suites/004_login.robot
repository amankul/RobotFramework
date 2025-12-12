*** Settings ***
Documentation     A test suite containing tests related to login functionality.
Metadata          Version       1.0
Metadata          Test Case     AAI-T231
Metadata          Test Case     AAI-T684
Default Tags      CARPO  Login
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
${MAX_ATTEMPTS}   ${5}

*** Test Cases ***
Login With Invalid Credentials Should Fail
    [Template]  Testing ${credentials} with ${username} and ${password} Should Be ${expected}
    [Tags]  Smoke  Production  Negative
    [Documentation]   A test that verifies all of the invalid login combinations.
    ...
    ...               The last login is a valid login such that the Okta counter is reset.
    ...               Okta has a 15 minute lock out after 5 failed login attempts.
    ...
    ...               These tests are data-driven to call the test case with different arguments to cover
    ...               different scenarios.
    Empty Username And Password      ${EMPTY}         ${EMPTY}              Credentials Required
    Invalid Username                 invalid          ${VALID PASSWORD}     Invalid Username
    Invalid Password                 ${VALID USER}    invalid               Invalid Password
    Invalid Username And Password    invalid          whatever              Invalid Username
    Empty Username                   ${EMPTY}         ${VALID PASSWORD}     Username Required
    Empty Password                   ${VALID USER}    ${EMPTY}              Password Required
    Valid Credentials                ${VALID USER}    ${VALID PASSWORD}     Valid Credentials

Validate Email Address Formats
    [Template]  Testing ${test type} for Email Address ${email address} Should Be ${expected}
    [Tags]  Regression
    [Documentation]   A test related to validating the Username format according to RFC 5322.
    ...
    ...               Acceptable email prefix formats
    ...                 The local part can be up to 64 characters in length and consist of any combination of alphabetic characters, digits, or any of the following special characters:
    ...
    ...                 ! # $ % & ‘ * + – / = ? ^ _ ` . { | } ~
    ...
    ...                 NOTE: The period character (“.”) is valid for the local part subject to the following restrictions:
    ...                     1. it is not the first or last character
    ...                     2. two or more consecutive periods
    ...
    ...                 Allowed characters: letters (a-z), numbers, underscores, periods, and dashes.
    ...                 An underscore, period, or dash must be followed by one or more letter or number.
    ...
    ...               Acceptable email domain formats
    ...                 Allowed characters: letters, numbers, dashes.
    ...                 The last portion of the domain must be at least two characters, for example: .com, .org, .cc
    ...                 Domain names can contain hyphens, but they cannot begin or end with a hyphen or contain consecutive hyphens.
    ...
    ...               These tests are data-driven by their nature. They use a single keyword, specified with Test Template setting,
    ...               that is called with different arguments to cover different scenarios.
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

User is Locked Out after 5 Unsuccessful Login Attempts
    [Tags]  Regression  Postive  AAI-T231
    [Documentation]  A test to verify that the user is locked out for 15 minutes after 5 unsuccessful login attempts.
    Log In As External Client  ${VALID_USER}  ${VALID_PASSWORD}  # Login to reset attempt counter
    Logout User
    Wait Until Element is Visible  ${LOGIN_USERNAME}
    Login Page Should Be Open

    FOR  ${index}    IN RANGE    ${MAX_ATTEMPTS}
        Log In  ${VALID_USER}  whatever  # Invalid login attempt
        Sleep  1s
        Run Keyword If  ${index} < ${MAX_ATTEMPTS - 1}  Invalid Username or Password
        ...  ELSE  User Should Be Locked Out
        Reload Page
    END

    # Login with a valid username and passord to verify lock out
    Log In  ${VALID_USER}  ${VALID_PASSWORD}
    User Should Be Locked Out
    Reload Page

    # Wait for a little over 15 minutes to verify that Okta releases the user lockout
    Sleep  ${LOCK_OUT_DELAY}
    Log In As External Client  ${VALID_USER}  ${VALID_PASSWORD}
    My d Page Should Be Open

*** Keywords ***
Remember Me Caches the Username
    [Tags]  Regression  Postive  AAI-T684
    [Documentation]  IN-PROCESS
    Checkbox Should Not Be Selected  ${LOGIN_REMEMBER_ME}
    Select Remember Me
    Log In As External Client  ${VALID_USER}  ${VALID_PASSWORD}

    Return to Login Page

    # Log back in to validate the username was stored correctly
    Input Password  ${VALID_PASSWORD}
    Submit Credentials
    My d Page Should Be Open

    # Verify that credentials are maintained through browser sessions
    Logout User
    Close Browser
    Open My d Page  existingSession=True
    ${username}=  Get Value  ${LOGIN_USERNAME}
    Should Be Equal  ${username}  ${VALID_USER}
    Checkbox Should Be Selected  ${LOGIN_REMEMBER_ME}

    # Clear the browser cache
    Delete All Cookies
    Logout User
    Wait Until Element is Visible  ${LOGIN_USERNAME}
    Login Page Should Be Open
    ${username}=  Get Value  ${LOGIN_USERNAME}
    Should Be Equal  ${username}  ${EMPTY}
    Checkbox Should Not Be Selected  ${LOGIN_REMEMBER_ME}

Testing ${credentials} with ${username} and ${password} Should Be ${expected}
    [Documentation]  Template used to login into the Client site.
    Log  Testing ... ${credentials} ${username} ${password}  console=yes
    Input Username    ${username}
    Input Password    ${password}
    Submit Credentials
    Run Keyword if  '${expected}' == 'Valid Credentials'   Run Keyword and Continue on Failure    My d Page Should Be Open
    ...  ELSE IF  '${expected}' == 'Invalid Username'      Run Keyword and Continue on Failure    Login Should Have Failed Username
    ...  ELSE IF  '${expected}' == 'Username Required'     Run Keyword and Continue on Failure    Login Should Have Failed Username Required
    ...  ELSE IF  '${expected}' == 'Password Required'     Run Keyword and Continue on Failure    Login Should Have Failed Password
    ...  ELSE IF  '${expected}' == 'Invalid Password'      Run Keyword and Continue on Failure    Invalid Username or Password
    ...  ELSE IF  '${expected}' == 'Credentials Required'  Run Keyword and Continue on Failure    Login Should Have Failed
    ...  ELSE  Log  Invalid expected result: ${expected}  console=yes

Testing ${test type} for Email Address ${email address} Should Be ${expected}
    [Documentation]  Template used to validate the email address format.
    Log  Testing ... ${test type}  console=yes
    Input Username    ${email address}
    Press Keys  ${LOGIN_USERNAME}    TAB  # Tab to Password to allow for pre-check on Username
    Run Keyword if  '${expected}' == 'valid'  Run Keyword and Continue on Failure    Username Should Be Valid
    ...  ELSE  Run Keyword and Continue on Failure    Username Should Have Failed

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