*** Settings ***
Resource       ../env/${environment}.resource
Resource       ../pages/CARS/CARSHomePage.robot
Resource       ../pages/GIPS/GIPSHomePage.robot
Resource       ../pages/GlobalKeywords.robot
Resource       ../pages/GlobalVariables.robot
Resource       ../pages/History/HistoryHomePage.robot
Resource       ../pages/InvestorReporting/InvestorReportingAccountSetup.robot
Resource       ../pages/InvestorReporting/InvestorReportingHomePage.robot
Resource       ../pages/People/PeopleHomePage.robot
Resource       ../pages/PlatinumReporting/PlatinumReportingHomePage.robot
Resource       ../pages/QLIK/QlikDashboardHomePage.robot
Resource       ../pages/TradingScreen/TradingScreensHomePage.robot
Resource       ../pages/FMS/FMSHomePage.robot
Resource       ../pages/Jenkins/JenkinsJobPage.robot
Suite Setup    Get-Credentials
Test Setup     Initialize Browser
Test Timeout       15 minutes

*** Test Cases ***
Verify Cvent
    [Tags]    SERVERSAT
    [Documentation]  This test is Cvent API health check.Payload is empty currently.
    ${cvent_health}      Catenate        SEPARATOR=      ${CVENT_URL}          /cventapi/health
    Load-As-Web-Service         ${cvent_health}


Verify CRM Accounts Endpoint
    [Tags]    SERVERSAT
    [Documentation]  This test is CRM API health check. Payload is empty currently.
    ${crm_health}      Catenate        SEPARATOR=      ${CRM_API_URL}          /crmapi/health
    Load-As-Web-Service         ${crm_health}


Verify People Page
    [Tags]    SERVERSAT
    [Documentation]  This test verifies user can search for executives and navigate between standard & quotes tab
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${PEOPLE_URL}

    Search Executive    ${People_ExecSearch}
    Verify Quote in Bio and Languages       ${People_Bio}      ${People_BioLanguages}


Verify Trading Screens
    [Tags]             SERVERSAT
    [Documentation]    This test verifies rendering of diff trading screens.
    Log    Opening Trading Screens    console=True
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${SCREENS_URL}/ScreensTradingSide
    Get Text    ${TradingScreensHomePage_Label_SlideType}    ==    Equity
    Go To    ${SCREENS_URL}/trading-austin-9-panel/
    Run Keyword And Continue On Failure    Wait For Condition    Element States    ${TradingScreensHomePage_Label_ModuleTitle}    contains    visible
    Load-As-Web-Service    ${SCREENS_URL}/trading-london


Verify Break Area Slides
    [Tags]    SERVERSAT
    [Documentation]  This test verifies rendering and transitions on break area slides
    Log      Opening Break Area Slides     console=True
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${SCREENS_URL}/break-area-austin
    Verify Slide Transition on Break Area


Verify History Factory
    [Tags]    SERVERSAT
    [Documentation]  This test verifies homepage, projector and videos for history factory
    Log      Opening History Page     console=True
    Run Keyword And Continue On Failure     Test History Page
    Run Keyword And Continue On Failure     Load-As-Web-Service     ${HISTORY_URL}/projector
    Test History Videos


Verify Investor Reporting
    [Tags]    SERVERSAT
    [Documentation]  This test verifies investor reporting for accessibility, account setup and status report grid
    Set To Dictionary        ${context_opt}       httpCredentials=${CREDS}
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}       url=${INVESTOR_REPORTING_URL}
    Run Keyword And Continue On Failure     Ensure Data Appears In Status Report Grid
    Take Screenshot
    Click    ${InvestorReportingHomePage_Button_AccountSetupMenu}
    Run Keyword And Continue On Failure     Ensure Data Appears In Account Setup Grid
    Confirm Setup Detail Page



Verify GIPS
    [Tags]    SERVERSAT
    [Documentation]  This test verifies accessibility for GIPS application.
    Set To Dictionary        ${context_opt}       httpCredentials=${CREDS}
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}       url=${GIPS_URL}
    Run Keyword And Ignore Error        Wait For Load State        networkidle
    Run Keyword And Continue On Failure     Get Element Count       ${GIPSHomePage_Table_Rows}    >    500
    Take Screenshot


Verify CARS
    [Tags]    SERVERSAT
    [Documentation]  This test verifies accessibility for CARS application.
    Set To Dictionary        ${context_opt}       httpCredentials=${CREDS}
    Run Keyword And Continue On Failure     New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CARS_URL}
    Run Keyword And Continue On Failure     Wait For Elements State    ${CARSHomePage_Table_BusinessDataGrid}
    Take Screenshot


Verify Platinum Reporting
    [Tags]    SERVERSAT
    [Documentation]  This test verifies reports can be run by a user in Platinum Reporting
    ## Hardcoding browser to firefox to avoid NTLM and use provided credentials
    Set To Dictionary        ${browser_opt}       browser=firefox
    Set To Dictionary        ${context_opt}       httpCredentials=${CREDS}
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${PLATINUM_REPORTING_URL}
    Run Keyword And Continue On Failure     Run Transaction Reports
    Go To       ${PLATINUM_REPORTING_URL}
    Run Institutional Extracts

Verify Fee Management System
    [Tags]    SERVERSAT
    [Documentation]  This test verifies user can access FMS application and load up the vehicle fees page
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${FMS_URL}
    Run Keyword And Ignore Error    Keyboard Key    press    Escape
    Fill Text    ${Okta_Username}    ${AD_Email}
    Fill Text    ${Okta_Password}   ${AD_Password}
    Click    ${Okta_Submit}
    Click    ${FMSHome_Button_DSMARevenueManagement}
    Click    ${FMSHome_MenuOption_VehicleFees}
    Wait For Condition    Element Count    ${FMSVehicleFees_Rows_VehicleGrid}     ==    10

Verify CRM-Cvent Integration
    [Tags]    SERVERSAT
    [Documentation]  This test verifies user can check status of Jenkins builds that define integration between CRM and Cvent
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${JENKINS_URL}/job/prod_crmsync_data_new/
    Fill Text    ${JenkinsLogin_Text_Username}     ${AD_Username}
    Fill Text    ${JenkinsLogin_Text_Password}   ${AD_Password}
    Click        ${JenkinsLogin_Button_Submit}
    Run Keyword And Continue On Failure     Check Latest Jenkins Run        prod_crmsync_data_new
    Run Keyword And Continue On Failure     Go To    ${JENKINS_URL}/job/prod_cventsync_data_new/
    Run Keyword And Continue On Failure     Check Latest Jenkins Run        prod_cventsync_data_new
    Run Keyword And Continue On Failure     Go To    ${JENKINS_URL}/job/prod_crmsync_schema_new/
    Check Latest Jenkins Run        prod_crmsync_schema_new
