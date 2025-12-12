# This is page object for "innovation-lab/becoming-a-retirement-plan-advisor" restricted to Succession
*** Variables ***

${SuccessionCMSPage_Title_AccessDenied}     Access Denied
${SuccessionCMSPage_Title_AccessGranted}    Retirement Plan

*** Keywords ***

Verify Succession Access For Given User
    [Arguments]        ${user}
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${CLIENT_SITE_CMS_URL}/login
    Make Client Site Login    user=${user}    firstime=False
    Open Profile Preferences
    Change UX Country       United Kingdom
    Go To       ${CLIENT_SITE_CMS_URL}/${Succession_CMSPage_Path}
    Run Keyword And Continue On Failure            Run Keyword If  ${user} == ${ClientSite_SuccessionLogin}      Wait For Condition        Title    *=    ${SuccessionCMSPage_Title_AccessGranted}
        ...  ELSE      Wait For Condition        Title    *=    ${SuccessionCMSPage_Title_AccessDenied}
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    Go To       ${CLIENT_SITE_CMS_URL}/${Succession_CMSPage_Path}
    Wait For Condition        Title    *=    ${SuccessionCMSPage_Title_AccessDenied}
