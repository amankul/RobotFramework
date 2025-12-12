*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported SeleniumLibrary.
Library           SeleniumLibrary
Library           OperatingSystem

*** Variables ***
${aPasswordWithNoLetters}               12345678!
${aPasswordWithNoDigits}                ABCDEFGH!
${aPasswordWithNoPunctuation}           ABCDEFGH1234
${aTooShortPassword}                    ABCDEF!
${aTooLongPassword}                     A!1234567890123456789012345678901234567890123456789012345678901234567890
${aMinimumLengthPassword}               ABCDEFG!
${aMaximumLengthPassword}               AB!123456789012345678901234567890123456789012345678901234567890
${aPasswordContainingUserName}          dddx+Saltheart.Foamfollower@gmail.com1
${aPasswordContainingFirstName}         SaltheartM7!
${aPasswordContainingLastName}          SFoamfollower7!
${DELAY}                                0
${INCORRECT_LOGIN}                      The username or password are incorrect
${LOCK_OUT_DELAY}                       930s  #seconds - 15 Minutes + 30 seconds as a buffer for clocks
${MSG_USERNAME_REQUIRED}                Email is required
${MSG_PASSWORD_REQUIRED}                Password is required
${MSG_INVALID_USERNAME}                 Email The username or password are incorrect
${MSG_VALID_USERNAME}                   Username
${MSG_MAX_LOGIN_ATTEMPTS}               You have reached the maximum number of login attempts. Please reset your password or contact your d representative.
${SECURITY QUESTION ANSWER}             Teddy
${VALID USER}                           dddx+Saltheart.Foamfollower@gmail.com
${VALID PASSWORD}                       Hlbbrs7!
${SHADFORTH USER}                       dddx+Shadforth.TestUser@gmail.com
${SHADFORTH PASSWORD}                   Hu]f^5]v3Bxxng7y

*** Keywords ***
Log In As d Employee
    Login Page Should Be Open
    Click Element  ${CLICK_HERE_EMPLOYEE_LOGIN}
    My d Page Should Be Open

Log In
    [Arguments]    ${username}      ${password}
    Login Page Should Be Open
    ${AcceptCookies}=  Run Keyword and Return Status  Element Should Be Visible  ${COOKIES_ACCEPT}
    Run Keyword If  ${AcceptCookies}  Click Button  ${COOKIES_ACCEPT}
    Input Username  ${username}
    Input Password  ${password}
    Submit Credentials

Log In As External Client
    [Arguments]    ${username}      ${password}
    Log In  ${username}      ${password}
    My d Page Should Be Open
    @{names}=  Split String  ${username}  ${SPACE}

Login Should Have Failed
    Login Page Should Be Open
    Element Should Be Visible  ${LOGIN_USERNAME_REQUIRED}
    Element Should Be Visible  ${LOGIN_PASSWORD_REQUIRED}
    Element Text Should Be  ${LOGIN_USERNAME_REQUIRED}  ${MSG_USERNAME_REQUIRED}
    Element Text Should Be  ${LOGIN_PASSWORD_REQUIRED}  ${MSG_PASSWORD_REQUIRED}

Invalid Username or Password
    Login Page Should Be Open
    Element Should Be Visible  ${LOGIN_INCORRECT}
    Element Text Should Be  ${LOGIN_INCORRECT}  ${INCORRECT_LOGIN}

Login Should Have Failed Username
    Login Page Should Be Open
    Element Should Be Visible  ${LOGIN_USERNAME_REQUIRED}
    Element Text Should Be  ${LOGIN_USERNAME_REQUIRED}  ${MSG_INVALID_USERNAME}

Login Should Have Failed Username Required
    Login Page Should Be Open
    Element Should Be Visible  ${LOGIN_USERNAME_REQUIRED}
    Element Text Should Be  ${LOGIN_USERNAME_REQUIRED}  ${MSG_USERNAME_REQUIRED}

Login Should Have Failed Password
    Login Page Should Be Open
    Element Should Be Visible  ${LOGIN_PASSWORD_REQUIRED}
    Element Text Should Be  ${LOGIN_PASSWORD_REQUIRED}  ${MSG_PASSWORD_REQUIRED}

User Should Be Locked Out
    Login Page Should Be Open
    Element Should Be Visible  ${LOGIN_MAX_ATTEMPTS}
    Element Text Should Be  ${LOGIN_MAX_ATTEMPTS}  ${MSG_MAX_LOGIN_ATTEMPTS}

Login Page Should Be Open
    Wait until element is visible  ${ACCESS_AND_AUTH_BOX}  20s
    Title Should Be    Client Login | d Fund Advisors

My d Page Should Be Open
    Wait until element is visible    ${NUM_ITEMS}  30s
    Title Should Be    My d
    #${cookies}=  Get cookies
    #Log  Page Cookies are ${cookies}  console=yes

Select Remember Me
    Select Checkbox  ${LOGIN_REMEMBER_ME}
    Checkbox Should Be Selected  ${LOGIN_REMEMBER_ME}

Unselect Remember Me
    Unselect Checkbox  ${LOGIN_REMEMBER_ME}
    Checkbox Should Not Be Selected  ${LOGIN_REMEMBER_ME}

Logout User
    Element Should Be Visible  ${USER_PROFILE}
    Click Button  ${USER_PROFILE}
    Click Element  ${PROFILE_SIGN_OUT}
    Login Page Should Be Open

Rejects passwords that omit required character types
    Run keyword and continue on failure  Rejects Password  ${aPasswordWithNoLetters}
    Run keyword and continue on failure  Rejects Password  ${aPasswordWithNoDigits}
    Run keyword and continue on failure  Rejects Password  ${aPasswordWithNoPunctuation}

Rejects passwords with bad lengths
    # Password MUST be at least 8 characters and no more than 72 characters
    Run keyword and continue on failure  Rejects Password  ${aTooShortPassword}
    Run keyword and continue on failure  Rejects Password  ${aTooLongPassword}

Accepts minimum and maximum length passwords
    # Password MUST be at least 8 characters and no more than 72 characters
    Run keyword and continue on failure  Accepts Password  ${aMinimumLengthPassword}
    Run keyword and continue on failure  Accepts Password  ${aMaximumLengthPassword}

Rejects passwords that contain illegal phrases
    Run keyword and continue on failure  Rejects Password  ${aPasswordContainingUserName}
    # Disabled in Okta
    #Run keyword and continue on failure  Rejects Password  ${aPasswordContainingFirstName}
    #Run keyword and continue on failure  Rejects Password  ${aPasswordContainingLastName}

Accepts Password
    [Arguments]  ${password}
    No Operation

Rejects Password
    [Arguments]  ${password}
    No Operation

Input Username
    [Arguments]    ${username}
    Input Text    ${LOGIN_USERNAME}    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    ${LOGIN_PASSWORD}    ${password}

Submit Credentials
    Click Button    ${LOGIN_BUTTON}
    Sleep  1
