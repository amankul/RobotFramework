# This is page object for "dev-lab/qa-test-pages/content-pages/david-booth-on-the-old-normal" restricted to Shadforth
*** Variables ***

${ShadforthCMSPage_Title_AccessDenied}     Access Denied
${ShadforthCMSPage_Title_AccessGranted}    David Booth

*** Keywords ***

Verify Shadforth Access For Given User
    [Arguments]        ${user}
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${CLIENT_SITE_CMS_URL}/login
    Make Client Site Login    user=${user}    firstime=False
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    Go To       ${CLIENT_SITE_CMS_URL}/${Shadforth_CMSPage_Path}
    Run Keyword And Continue On Failure    Wait For Condition        Title    should start with    ${ShadforthCMSPage_Title_AccessDenied}
    Open Profile Preferences
    Change UX Country       Australia
    Go To       ${CLIENT_SITE_CMS_URL}/${Shadforth_CMSPage_Path}
    Run Keyword If  ${user} == ${ClientSite_ShadforthLogin}      Wait For Condition        Title    should start with    ${ShadforthCMSPage_Title_AccessGranted}
        ...  ELSE      Wait For Condition        Title    should start with    ${ShadforthCMSPage_Title_AccessDenied}
