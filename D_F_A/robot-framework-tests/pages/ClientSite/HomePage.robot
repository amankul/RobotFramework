*** Variables ***
${HomePage_Link_ProfileExpand}                   [data-qa="header-profile-link"]
${HomePage_Link_ProfilePreferences}              [data-qa="header-profile-preferences"]
${HomePage_Button_SignOut}                       [data-qa="home-page-button-signout"]
${HomePage_Label_LoggedUser}                     [data-qa="home-page-label-logged-user"]
${HomePage_Container_PageBody}                   [data-qa="content-page"],[data-qa="collection-page"],[id="player"]
${HomePage_Div_PrimaryArticle}                   [data-qa='home-featured-main-article-link']
${HomePage_Div_FeaturedArea}                     [data-qa="home-featured-main"]
${HomePage_Image_Logo}                           [data-qa="home-page-image-logo"]
${HomePage_Links_Header}                         [data-qa="header-link-button"]
${HomePage_Links_MyAccounts}                     [data-qa="header-secondary-header-nav-item"] >> text=My Accounts
${HomePage_Links_Investments}                    [data-qa="header-link-label-Investments"],[data-qa="header-link-label-Funds"]
${HomePage_Links_Tools}                          [data-qa="header-link-label-Tools"]
${HomePage_Label_CountryIndicator}               [data-qa^="header-country-indicator-"]
${HomePage_Button_BrowseBySort}                  [data-qa^="coveo-headless-sort-value-"]
${HomePage_Dropdown_BrowseBySortOptions}         [data-qa^="coveo-headless-sort-item-"]
${HomePage_Button_BrowseByFilter}                [data-tag="FILTER+PLACEHOLDER"]
${HomePage_Div_FirstCoveoFilterResultTitle}      .coveo-headless-card-layout-container > div:first-child >> h3
${HomePage_Button_FilterSelection}               [data-qa^="coveo-headless-facet"]
${HomePage_Text_AppliedFilter}                   [data-qa="breadcrumb-caption"]


*** Keywords ***

Open Profile Preferences
    [Documentation]    Change country from Profile preferences on client site
    Click       ${HomePage_Link_ProfileExpand}
    Click       ${HomePage_Link_ProfilePreferences}

Sign Out of Client Site
    [Documentation]    Logs out of current session
    Click       ${HomePage_Link_ProfileExpand}
    Click       ${HomePage_Button_SignOut}

Verify Headers
    [Documentation]    Verifies all header links are accessible
    ${headers}         Get Elements        ${HomePage_Links_Header}
    FOR     ${header}      IN      @{headers}
        ${old_url}      Get Url
        Run Keyword And Continue On Failure     Click        ${header}
        Run Keyword And Continue On Failure     Get Url     !=      ${old_url}
        Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
        Run Keyword And Continue On Failure     Go Back
    END

Get NAV Headers
    ${headers}         Get Elements        ${HomePage_Links_Header}
    ${labels}  	    Create List
    FOR     ${header}      IN      @{headers}
            ${nav}      Get Text        ${header}
            Append To List      ${labels}       ${nav}
    END
    RETURN        ${labels}

Set Country To USA If Not Already
    [Documentation]    Check current country, if non-US change to USA
    ${current_country_sel}      Get Text        ${HomePage_Label_CountryIndicator}
    IF      '${current_country_sel}' != 'US'
            Open Profile Preferences
            Run Keyword And Continue On Failure     Change UX Country       United States
            Click       ${HomePage_Image_Logo}
    END


Check Presence of Sort Options
    [Documentation]     Check sort options in Browse Bar
    ${current}      Get Text        ${HomePage_Button_BrowseBySort}         ==      SORT BY: NEWEST
    Run Keyword And Continue On Failure     Focus         ${HomePage_Button_BrowseBySort}
    Click       ${HomePage_Button_BrowseBySort}
    ${locators_sort}     Get Elements        ${HomePage_Dropdown_BrowseBySortOptions}
    FOR     ${loc}      IN      @{locators_sort}
            Run Keyword And Continue On Failure     Get Text      ${loc}        validate      value.upper() in ["NEWEST","RELEVANCY"]
    END


Filter Cards Using Given Browse By Option
    [Arguments]         ${filter}       ${value}
    [Documentation]     Filter Browse By area using topic, format and use.
    ${filter_loc}    Replace String      ${HomePage_Button_BrowseByFilter}    FILTER+PLACEHOLDER    ${filter}
    Run Keyword And Continue On Failure     Hover       ${filter_loc}
    Run Keyword And Continue On Failure     Focus       ${filter_loc}
    Evaluate Javascript         ${filter_loc}         (elem) => elem.click()
    Click       ${HomePage_Button_FilterSelection} >> "${value}"
    Wait For Condition    Property    ${HomePage_Text_AppliedFilter}    textContent    ==    ${value}
    Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
    ${title}      Get Text        ${HomePage_Div_FirstCoveoFilterResultTitle}
    Click       ${HomePage_Div_FirstCoveoFilterResultTitle}
    Run Keyword And Continue On Failure     Wait Until Keyword Succeeds     2x      200ms     Get Title      *=      ${title}