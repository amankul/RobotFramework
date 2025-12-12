*** Variables ***
${LoginPage_InputField_Email}               [data-qa="login-email-field"]
${LoginPage_InputField_Password}            [data-qa="login-password-field"]
${LoginPage_Button_Submit}                  [data-qa="submit-button-login"]
${LoginPage_Link_VerifyIdentity}            "try another method"
${LoginPage_InputField_Answer}              [data-qa="second-factor-identify-question-answer-field"]
${LoginPage_Button_Next}                    [data-qa="second-factor-identify-next-button"]
${LoginPage_Button_VerificationComplete}    [data-qa="continue-to-my-d-button"]

*** Keywords ***

Make Client Site Login
    [Arguments]        ${user}         ${firstime}=True
    [Documentation]    Login into client site with given user. For relogin set arg to False.
    Fill Text       ${LoginPage_InputField_Email}     ${user}[0]
    Fill Text       ${LoginPage_InputField_Password}     ${user}[1]
    Click       ${LoginPage_Button_Submit}
    IF      ${firstime}
        Run Keyword And Continue On Failure     Click       ${LoginPage_Link_VerifyIdentity}
        Run Keyword And Continue On Failure     Fill Text       ${LoginPage_InputField_Answer}        ${ClientSite_Login_AnotherMethod_SecurityAnswer}
        Run Keyword And Continue On Failure     Click       ${LoginPage_Button_Next}
        Click       ${LoginPage_Button_VerificationComplete}
        Take Screenshot     fullPage=True
    END
