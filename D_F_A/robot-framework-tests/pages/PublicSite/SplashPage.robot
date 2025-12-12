## This is for new public site(Sep 2022)


*** Variables ***
${SplashPage_Button_AudienceType}            [data-qa="audience-button-PLACEHOLDER+AUDIENCE"]
${SplashPage_Checkbox_Affirmation}           [data-qa*="-checkbox"]
${SplashPage_Button_AcceptContinue}          [data-qa="professional-affirmation-button"],[data-qa="professional-affirmation-mobile-button"]
${SplashPage_Page_UnknownSplash}             [data-qa="unknown-audience-splash-page"]
${SplashPage_Page_GlobalSplash}              [data-qa="public-global-splash"]
${SplashPage_Text_GlobalSplashCountry}       [data-qa="public-global-splash-country"]
${SplashPage_Modal_AudienceSelector}         .audience-selector-from-link-modal
${SplashPage_Link_LocationChange}             [data-qa="audience-link-locationchange"]
${SplashPage_Container_AffirmationHeader}    .professional-affirmation-header-container
${Mismatch_BannerText}                        Please use the menu to change your preferences

*** Keywords ***
Affirm For Professionals
    Click    ${SplashPage_Checkbox_Affirmation}
    Click    ${SplashPage_Button_AcceptContinue}

Select Audience
    [Arguments]     ${audience}
    [Documentation]     Open page for given audience
    ${aud}    Replace String      ${SplashPage_Button_AudienceType}    PLACEHOLDER+AUDIENCE    ${audience}
    ${selected_audience}    Get Text    ${aud}
    Click     ${aud}
    Run Keyword If    '${TEST_NAME}' == 'Verify Public Site Headers and Footers'    Log    Currently viewing audience: ${selected_audience}    console=True
    Run Keyword If    '${TEST_NAME}' == 'Verify Public Site Headers and Footers'    Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True
    IF      "${audience}"=="professional"
            Run Keyword And Continue On Failure     Affirm For Professionals
    END


Check Splash Page States
    [Arguments]    ${unknown_state}    ${global_state}
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}
    Run Keyword And Continue On Failure    Get Element States    ${SplashPage_Page_UnknownSplash}    contains    ${unknown_state}
    Get Element States    ${SplashPage_Page_GlobalSplash}    contains    ${global_state}


Verify Blurred Individual Page With Shared URL
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/insights
    Run Keyword And Continue On Failure    Wait For Elements State    ${SplashPage_Modal_AudienceSelector}    visible
    Run Keyword And Continue On Failure    Get Text    ${SplashPage_Link_LocationChange}    ==    Change location
    Run Keyword And Continue On Failure    Wait For Function       () => dataLayer[0]["audience"]=="individual investor"
    Run Keyword And Continue On Failure    Wait For Function       () => dataLayer[0]["splash"]==2
    Close Browser


Verify Affirmation For Professional Only URL
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/financial-professionals
    Run Keyword And Continue On Failure    Wait For Elements State    ${SplashPage_Container_AffirmationHeader}   visible    5s
    Run Keyword And Continue On Failure    Wait For Function       () => dataLayer[0]["audience"]=="financial professional"
    Run Keyword And Continue On Failure    Affirm For Professionals
    Run Keyword And Continue On Failure    Wait For Function     () => dataLayer.some(dict => dict['event'] === 'page_view')
    Run Keyword And Continue On Failure    Go To   ${PUBLIC_SITE_URL}/ca-en/insights
    Run Keyword And Continue On Failure    Get Element States    ${SplashPage_Container_AffirmationHeader}     contains    visible
    Close Browser

Verify Mismatch Banner
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/individual
    Run Keyword And Continue On Failure    Wait For Load State    domcontentloaded    5s
    Run Keyword And Continue On Failure    Go To   ${PUBLIC_SITE_URL}/ca-en/individual
    Run Keyword And Continue On Failure    Wait For Elements State    text=${Mismatch_BannerText}     visible    5s
    Close Browser

Verify Unapproved Country Professional Page
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/jp-en/insights
    Run Keyword And Continue On Failure    Wait For Function       () => dataLayer[0]["splash"]==3
    Run Keyword And Continue On Failure    Wait For Elements State    ${SplashPage_Container_AffirmationHeader}     visible    5s
    Run Keyword And Continue On Failure    Get Title    contains   Page Not Found
    Close Browser

Verify Audience Preference on Global Splash
    [Arguments]    ${audience}    ${url_contains}
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}
    Run Keyword And Continue On Failure    Wait For Function       () => dataLayer[0]["splash"]==4
    IF      "${audience}"=="individual"
            Run Keyword And Continue On Failure     Click    ${SplashPage_Link_LocationChange}
            Run Keyword And Continue On Failure     Click    text="Australia"
            Click    div${SplashPage_Button_AudienceType.replace('PLACEHOLDER+AUDIENCE', '${audience}')}
    ELSE
            Run Keyword And Continue On Failure    Select Audience    ${audience}
    END
    Run Keyword And Continue On Failure     Wait For Condition     Url     Contains    ${url_contains}
    Close Browser