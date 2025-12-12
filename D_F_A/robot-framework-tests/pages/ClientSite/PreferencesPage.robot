*** Variables ***
${PreferencesPage_Link_TabPreferences}             [data-qa="profile-preferences-tab"]
${PreferencesPage_Link_Change}                     [data-qa="change-country"]
${PreferencesPage_Dropdown_ChangeCountry}          [data-qa="change-country-dropdown"]
${PreferencesPage_Button_AcceptChange}             [data-qa="profile-preference-accept-button"]
${PreferencesPage_Button_SelectionChangeBanner}    [data-qa="profile-preference-back-to-profile-button"]
${PreferencesPage_Label_Country}                   [data-qa="profile-preference-content-country"]

*** Keywords ***

Change UX Country
    [Arguments]     ${ctry}
    [Documentation]    Change country from Profile preferences section
    Click       ${PreferencesPage_Link_TabPreferences}
    Click       ${PreferencesPage_Link_Change}
    Click       ${PreferencesPage_Dropdown_ChangeCountry}
    Click       [aria-label="${ctry}"]
    Click       ${PreferencesPage_Button_AcceptChange}
    Run Keyword And Continue On Failure     Click       ${PreferencesPage_Button_SelectionChangeBanner}


Get Current Country
    [Documentation]    Return current country selection from Profile preferences section
    Run Keyword And Continue On Failure     Click       ${PreferencesPage_Link_TabPreferences}
    Run Keyword And Continue On Failure     Run Keyword And Return      Get Text        ${PreferencesPage_Label_Country}
