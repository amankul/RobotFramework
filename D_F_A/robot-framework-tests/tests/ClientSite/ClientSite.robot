*** Settings ***
Resource       ../../env/${environment}.resource
Resource       ../../pages/ClientSite/AccordianPage.robot
Resource       ../../pages/ClientSite/CollectionPage.robot
Resource       ../../pages/ClientSite/FeaturedCMSPage.robot
Resource       ../../pages/ClientSite/FundCenterPage.robot
Resource       ../../pages/ClientSite/HomePage.robot
Resource       ../../pages/ClientSite/IndividualAssetPage.robot
Resource       ../../pages/ClientSite/LoginPage.robot
Resource       ../../pages/ClientSite/MAMRPage.robot
Resource       ../../pages/ClientSite/OrderPage.robot
Resource       ../../pages/ClientSite/PausePage.robot
Resource       ../../pages/ClientSite/PDFConverterCMSPage.robot
Resource       ../../pages/ClientSite/PreferencesPage.robot
Resource       ../../pages/ClientSite/RegisterPage.robot
Resource       ../../pages/ClientSite/SearchPage.robot
Resource       ../../pages/ClientSite/ShadforthCMSPage.robot
Resource       ../../pages/ClientSite/SuccessionCMSPage.robot
Resource       ../../pages/ClientSite/ToolsPage.robot
Resource       ../../pages/GlobalKeywords.robot
Resource       ../../pages/GlobalVariables.robot
Suite Setup    Get-Credentials
Test Setup     Initialize Browser
Test Timeout       15 minutes

*** Test Cases ***

Confirm Navigation To Appropriate d Public Site
    [Tags]    SERVERSAT     REGRESSION    DAILYRUN
    [Documentation]  This test confirms individual investor is taken to appropriate country page
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}
    Request Access To Myd         ${RegisterPage_Button_IndividualInvestor}
    Run Keyword And Continue On Failure     Take Screenshot
    Run Keyword And Continue On Failure     Get Attribute    ${RegisterPage_Button_NavigateToPublicSite}       href    *=     individual
    Click       ${RegisterPage_Button_NavigateToPublicSite}
    Wait For Condition    Url     contains     us-en/individual

Confirm Investment Professional Registration
    [Tags]    SERVERSAT     REGRESSION
    [Documentation]  Verify investment professionals submitted registration reaches CRM
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}
    Request Access To Myd         ${RegisterPage_Button_InvestmentProfessional}
    Submit Registration
    Verify Registration in CRM
    Request Access To Myd         ${RegisterPage_Button_InvestmentProfessional}
    Verify Cannot Register With Existing Email

Verify MAMR Links
    [Tags]         REGRESSION    DAILYRUN    SERVERSAT
    [Documentation]  Verify MAMR Links open
    Set To Dictionary    ${browser_opt}    args=["--disable-web-security"]
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login      user=${ClientSite_MAMRLogin}
    Click       ${HomePage_Links_MyAccounts}
    Run Keyword And Continue On Failure     Ensure My Accounts Page Load
    Ensure My Reports Page Load

Confirm Country Selection Saved
    [Tags]    SERVERSAT     REGRESSION    DAILYRUN
    [Documentation]  Verify UX Country changes are retained
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login     user=${ClientSite_GenericLogin}    firstime=False
    Open Profile Preferences
    FOR     ${country}      IN      @{ClientSite_TestUX_CountryList}
        Run Keyword And Continue On Failure     Change UX Country           ${country}
        Run Keyword And Continue On Failure     Sign Out of Client Site
        Run Keyword And Continue On Failure     Make Client Site Login      firstime=False      user=${ClientSite_GenericLogin}
        Run Keyword And Continue On Failure     Open Profile Preferences
        ${current_country}     Get Current Country
        Run Keyword And Continue On Failure     Should Be Equal As Strings            ${current_country}       ${country}
    END

Verify Homepage, Logo and Primary Article
    [Tags]    SERVERSAT     REGRESSION    DAILYRUN
    [Documentation]  Verify logged user info and primary article rendering.Also logo brings back to homepage.
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login          user=${ClientSite_GenericLogin1}    firstime=False
    Run Keyword And Continue On Failure     Get Text         ${HomePage_Label_LoggedUser}      *=     ${ClientSite_TestUser}
    Wait For Load State    networkidle
    ${client_url}       Get Url
    Click       ${HomePage_Div_PrimaryArticle}
    Run Keyword And Continue On Failure      Wait For Condition    Element States    ${HomePage_Container_PageBody}    contains    visible
    Run Keyword And Continue On Failure      Get Url     !=      ${client_url}
    Go Back
    Run Keyword And Continue On Failure      Wait For Function       () => dataLayer[0]["pageType"]=="Home"
    Get Element States        ${HomePage_Image_Logo}        contains    visible

Verify Header & Footer
    [Tags]         REGRESSION    DAILYRUN
    [Documentation]  Verify header and footer links direct users to a valid page.Test will work only for US user.
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin2}    firstime=False
    Set Country To USA If Not Already
    Run Keyword And Continue On Failure     Verify Headers
    Verify Footer Links

Investments Page and Retirement Income Calculator
    [Tags]         REGRESSION    DAILYRUN    SERVERSAT
    [Documentation]  Verify all investment types(Funds, Models, UMAs) open. Test will work only for US user.
    Set To Dictionary    ${browser_opt}    args=["--disable-web-security"]
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin3}    firstime=False
    Set Country To USA If Not Already
    Click       ${HomePage_Links_Investments}
    Run Keyword And Continue On Failure     Ensure All Investments Showup
    Click       ${HomePage_Links_Tools}
    Open and Verify Retirement Income Calculator

Test Accordian Component On Sustainability-Investing Page
    [Tags]         REGRESSION
    [Documentation]  Verify accordian component and document metadata
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_CMS_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin4}     firstime=False
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    Go To       ${CLIENT_SITE_CMS_URL}/${Accordian_CMSPage_Path}
    Run Keyword And Continue On Failure     Check Metadata Section
    Run Keyword And Continue On Failure     Expand-Collapse Accordian
    Open and Download PDF

Check Featured Area Content
    [Tags]         REGRESSION
    [Documentation]  Verify page, asset and external page in featured area created on cms.
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin5}     firstime=False
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    Go To       ${CLIENT_SITE_CMS_URL}/${FeaturedArea_CMSPage_Path}
    Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
    ${home_featured_main}        Get Elements        ${HomePage_Div_FeaturedArea}
    FOR     ${featured_item}    IN       @{home_featured_main}
            Run Keyword And Continue On Failure     Check Featured Area Contents & Cards      ${featured_item}    ${home_featured_main.index('${featured_item}')}
    END

Verify The Browse Bar
    [Tags]         REGRESSION    DAILYRUN
    [Documentation]  Verify filtering with topic,format and use on browse bar.
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin6}     firstime=False
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    Run Keyword And Continue On Failure     Check Presence of Sort Options
    FOR     ${key}      ${value}    IN      &{BrowseBar_TopicFormatUse}
        Run Keyword And Continue On Failure     Filter Cards Using Given Browse By Option       ${key}      ${value}
        Click       ${HomePage_Image_Logo}
    END

Verify PDF Converter & Share
    [Tags]         REGRESSION
    [Documentation]  Verify pdf can be generated from article page. Also shareable links exist w/o xlink.
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_CMS_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin7}     firstime=False
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    Go To       ${CLIENT_SITE_CMS_URL}/${PDFConverter_CMSPage_Path}
    Run Keyword And Continue On Failure     Verify Share Modal
    Verify PDF Generation and Download

Verify Pause Page
    [Tags]         REGRESSION    DAILYRUN
    [Documentation]  Verify user sees pause page before external content and can navigate back/forth.
    Remove From Dictionary       ${context_opt}      userAgent
    Set To Dictionary        ${browser_opt}       headless=False
    Run Keyword If      '${browserlib}'!='firefox'     Set To Dictionary        ${browser_opt}       channel=chrome
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_CMS_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin8}     firstime=False
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    Go To          ${CLIENT_SITE_CMS_URL}/${Pause_CMSPage_Path}      timeout=60s
    Navigation BacknForth From Pause Page

Verify Download From Powerpoint Component
    [Tags]         REGRESSION
    [Documentation]  PDF/PPT asset downloads.
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin9}     firstime=False
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    Go To          ${CLIENT_SITE_CMS_URL}/${Powerpoint_CMSPage_Path}      timeout=60s
    Download Powerpoint

Verify Search And Filters
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify search and filters.
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${CLIENT_SITE_URL}/login
    Make Client Site Login    user=${ClientSite_GenericLogin10}    firstime=False
    Run Keyword And Continue On Failure    Verify Search Suggestions For    booth
    Run Keyword And Continue On Failure    Perform A Search For    booth
    Run Keyword And Continue On Failure    Verify Results Are Found
    Run Keyword And Continue On Failure    Verify Single Filters
    Run Keyword And Continue On Failure    Verify Multiple Filters
    Run Keyword And Continue On Failure    Perform A Search For    ${EMPTY}
    Run Keyword And Continue On Failure    Verify Fund Documents Specific Filters
    Run Keyword And Continue On Failure    Perform A Search For    Testing_No_Results_Page
    Run Keyword And Continue On Failure    Verify No Results Are Found

Verify Order Form
    [Tags]             REGRESSION
    [Documentation]    Verify printed materials can be ordered.
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${CLIENT_SITE_URL}/login
    Make Client Site Login    user=${ClientSite_GenericLogin11}    firstime=False
    Wait For Load State    networkidle
    Go To    ${CLIENT_SITE_URL}/order
    Run Keyword And Continue On Failure    Enter Quantity and Verify Subtotal
    Run Keyword If        '${environment}' in ['dev','uat']        Place Order

Verify Shadforth Access
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify content restricted for Shadforth is available only for those users.
    Run Keyword And Continue On Failure        Verify Shadforth Access For Given User        ${ClientSite_ShadforthLogin}
    Verify Shadforth Access For Given User        ${ClientSite_GenericLogin12}

Verify Succession Access
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify content restricted for Succession is available only for those users.
    Run Keyword And Continue On Failure        Verify Succession Access For Given User        ${ClientSite_SuccessionLogin}
    Verify Succession Access For Given User        ${ClientSite_GenericLogin13}

Verify IAP With Word File
    [Tags]         REGRESSION    DAILYRUN
    [Documentation]  Verify IAP page heading is visible and word asset can be downloaded.
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin14}     firstime=False
    Wait For Load State    networkidle
    Go To    ${CLIENT_SITE_URL}/${IAP_PathUS}
    Run Keyword And Continue On Failure        Wait For Elements State        ${IndividualAssetPage_Img_Asset}
    Run Keyword And Continue On Failure        Get Text     ${IndividualAssetPage_Div_Header}         *=        Cboe Filing
    ${href}    Run Keyword And Continue On Failure       Get Attribute    ${IndividualAssetPage_Link_DownloadFile}    href
    ${file_obj}     Run Keyword And Continue On Failure       Download Given Document            ${IndividualAssetPage_Link_DownloadFile}
    Should Contain 	${href}    ${file_obj.suggestedFilename}[-20:]

Verify Xlink Works
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Test just verifies whether xlink(already generated by employee) is accessible.
    Load-As-Web-Service           ${XLINK_MARKETNOMEMORY_URL}     testOnly=true

Verify Secondary Asset Container
    [Tags]        REGRESSION
    [Documentation]  Verify assets inside secondary asset container render as configured
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_CMS_URL}/login
    Make Client Site Login      user=${ClientSite_MAMRLogin1}     firstime=False
    Wait For Load State    networkidle
    Go To     ${CLIENT_SITE_CMS_URL}/${Accordian_CMSPage_Path}
    Wait For Load State    networkidle
    Check Individual Secondary Assets

Verify Collection Page Personalization
    [Tags]        REGRESSION
    [Documentation]  Verify the personalization on a collection page
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${CLIENT_SITE_CMS_URL}/login
    Make Client Site Login    user=${ClientSite_GenericLogin}    firstime=False
    Run Keyword And Continue On Failure    Set Country To USA If Not Already

    Run Keyword And Continue On Failure    Go To     ${CLIENT_SITE_CMS_URL}/${Collections_CMSPage_Path}
    Run Keyword And Continue On Failure    Check Personalized Collection Section Headers    USClientOnly    attached
    Run Keyword And Continue On Failure    Check Personalized Collection Section Headers    AUClientOnly    detached
    Run Keyword And Continue On Failure    Check Personalized Collection Section Headers    EmployeeOnly    detached
    Run Keyword And Continue On Failure    Check Personalized Collection Card Headers    1    attached
    Run Keyword And Continue On Failure    Check Personalized Collection Card Headers    3    detached

    Run Keyword And Continue On Failure    Open Profile Preferences
    Run Keyword And Continue On Failure    Change UX Country    Australia

    Run Keyword And Continue On Failure    Go To    ${CLIENT_SITE_CMS_URL}/${Collections_CMSPage_Path}
    Run Keyword And Continue On Failure    Check Personalized Collection Section Headers    AUClientOnly    attached
    Run Keyword And Continue On Failure    Check Personalized Collection Section Headers    USClientOnly    detached
    Run Keyword And Continue On Failure    Check Personalized Collection Section Headers    EmployeeOnly    detached
    Run Keyword And Continue On Failure    Check Personalized Collection Card Headers    5    attached
    Run Keyword And Continue On Failure    Check Personalized Collection Card Headers    6    detached

Confirm Myd Navigation
    [Tags]    SERVERSAT
    [Documentation]  This test confirms myd.com redirects to my.d.com
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=https://www.myd.com/login
    Wait For Condition    Url     contains     ${CLIENT_SITE_URL}