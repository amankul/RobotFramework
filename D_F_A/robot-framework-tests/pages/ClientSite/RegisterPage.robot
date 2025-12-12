*** Variables ***
${RegisterPage_Button_IndividualInvestor}        [data-qa="client-site-registration-individual-investor"]
${RegisterPage_Button_InvestmentProfessional}    [data-qa="client-site-registration-investment-professional"]
${RegisterPage_Button_NavigateToPublicSite}      [data-qa="client-site-registration-visit-public-site-btn"]
${RegisterPage_Dropdown_Countries}               [data-qa="client-site-registration-contact-form-dropdown-country"]
${RegisterPage_Link_GenericAriaLabel}            [data-qa="GENERIC+PLACEHOLDER"]
${RegisterPage_Checkbox_AcceptTerms}             [data-qa="client-site-registration-term-agreement-checkbox"]
${RegisterPage_Input_IPEmail}                    [data-qa="client-site-registration-email"]
${RegisterPage_Input_IPConfirmEmail}             [data-qa="client-site-registration-email-confirm"]
${RegisterPage_Button_Next}                      [data-qa="client-site-registration-next-btn"]
${RegisterPage_Button_Firm_Desc_Next}            [data-qa="client-site-registration-firm-desc-next-button"]
${RegisterPage_Button_Accept&Continue}           [data-qa="client-site-registration-accept-continue"]
${RegisterPage_Input_FirstName}                  [data-qa="client-site-registration-first-name"]
${RegisterPage_Input_LastName}                   [data-qa="client-site-registration-last-name"]
${RegisterPage_Input_CompanyName}                [data-qa="client-site-registration-company-name"]
${RegisterPage_Input_BizAddress}                 [data-qa="client-site-registration-business-address"]
${RegisterPage_Input_ZipCode}                    [data-qa="client-site-registration-zip-code"]
${RegisterPage_Input_City}                       [data-qa="client-site-registration-city"]
${RegisterPage_Input_PhoneNumber}                [data-qa="client-site-registration-phone-number"]
${RegisterPage_Dropdown_States}                  [data-qa="client-site-registration-state"]
${RegisterPage_Button_ExistingClient}            [data-qa="client-site-registration-not-existing-client"]
${RegisterPage_Dropdown_ProfessionalTypes}       [data-qa="client-site-registration-firm-description"]
${RegisterPage_Text_RegistrationCompleted}       [data-qa="client-site-registration-request-submitted"]
${RegisterPage_Text_UsedEmail}                   [data-qa="client-site-registration-email-error"]
${Reg_Url}                                       ${CLIENT_SITE_URL}/register

*** Keywords ***

Request Access To Myd
    [Arguments]        ${loc}
    [Documentation]    Open register page and tell us who you are
    Go To    ${Reg_Url}
    Click    ${loc}


Submit Registration
    [Documentation]    Verify investment professionals can submit registration
    ${timestamp}    Get Time    year month day hour min sec
    ${professional_email}    Catenate    SEPARATOR=    test-    @{timestamp}    @dfa.com
    Set Test Variable    ${professional_email}
    Fill Text    ${RegisterPage_Input_IPEmail}    ${professional_email}
    Fill Text    ${RegisterPage_Input_IPConfirmEmail}    ${professional_email}
    Click    ${RegisterPage_Button_Next}
    Click    ${RegisterPage_Dropdown_Countries}
    Click    ${RegisterPage_Link_GenericAriaLabel.replace("GENERIC+PLACEHOLDER","${Test_Country}")}
    Fill Text    ${RegisterPage_Input_FirstName}    ${Test_FirstName}
    Fill Text    ${RegisterPage_Input_LastName}    ${Test_LastName}
    Fill Text    ${RegisterPage_Input_CompanyName}    ${Test_CompanyName}
    Fill Text    ${RegisterPage_Input_BizAddress}    ${Test_BizAddress}
    Fill Text    ${RegisterPage_Input_ZipCode}    ${Test_ZipCode}
    Fill Text    ${RegisterPage_Input_City}    ${Test_City}
    Fill Text    ${RegisterPage_Input_PhoneNumber}    ${Test_PhoneNumber}
    Click    ${RegisterPage_Dropdown_States}
    Click    ${RegisterPage_Link_GenericAriaLabel.replace("GENERIC+PLACEHOLDER","${Test_State}")}
    Click    ${RegisterPage_Button_Next}
    Click    ${RegisterPage_Button_ExistingClient}
    Click    ${RegisterPage_Dropdown_ProfessionalTypes}
    Click    ${RegisterPage_Link_GenericAriaLabel.replace("GENERIC+PLACEHOLDER","${Test_ProfessionalType}")}
    Click    ${RegisterPage_Button_Firm_Desc_Next}
    Click    ${RegisterPage_Checkbox_AcceptTerms}
    Click    ${RegisterPage_Button_Accept&Continue}
    Run Keyword And Continue On Failure    Wait For Elements State    ${RegisterPage_Text_RegistrationCompleted}
    Take Screenshot    fullPage=True


Verify Registration in CRM
    [Documentation]    Verify CSI shows as pending registration in CRM
    ${headers_okta}    Create Dictionary    Content-Type=application/x-www-form-urlencoded    Accept=application/json    Cache-Control=no-cache
    Create Session    okta    ${OKTA_URL}    headers=${headers_okta}    auth=${OKTA_CLIENTID_CLIENTSEC}    verify=True
    ${response_okta}    POST On Session    okta    url=${OKTA_AUTH_SERVER}    data=grant_type=${Okta_GrantType}&scope=${Okta_Scope}
    Set Test Variable    ${token}    Bearer ${response_okta.json()}[access_token]
    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    3x    1s    Query Username in CRM


Query Username in CRM
    ${headers_crm}    Create Dictionary  Authorization=${token}
    ${response_crm}    GET    ${CRM_API_URL}/crmapi/v2/registration/verify_username    params=username=${professional_email}    headers=${headers_crm}
    Should Be True    ${response_crm.json()}[has_pending_registration]


Verify Cannot Register With Existing Email
    [Documentation]    Verify investment professional cannot register if their email exists in CRM
    Fill Text    ${RegisterPage_Input_IPEmail}    ${professional_email}
    Fill Text    ${RegisterPage_Input_IPConfirmEmail}    ${professional_email}
    Click    ${RegisterPage_Button_Next}
    Run Keyword And Continue On Failure    Wait For Elements State    ${RegisterPage_Text_UsedEmail}