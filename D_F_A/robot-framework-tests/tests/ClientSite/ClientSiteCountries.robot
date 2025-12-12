*** Settings ***
Resource       ../../env/${environment}.resource
Resource       ../../pages/ClientSite/FundCenterPage.robot
Resource       ../../pages/ClientSite/HomePage.robot
Resource       ../../pages/ClientSite/LoginPage.robot
Resource       ../../pages/ClientSite/PreferencesPage.robot
Resource       ../../pages/ClientSite/ToolsPage.robot
Resource       ../../pages/GlobalKeywords.robot
Resource       ../../pages/GlobalVariables.robot
Suite Setup    Run Keywords    Get-Credentials    Get Yaml Data
Test Setup     Initialize Browser
Test Timeout       30 minutes

*** Keywords ***
Get Yaml Data
    ${yaml_data}        Load Yaml       robot-framework-tests/env/clientcountryconfig.yml
    Set Suite Variable      ${yaml_data}


Ensure Header Labels Match For Given Country
    [Arguments]     ${country}
    Run Keyword And Continue On Failure     Change UX Country     ${yaml_data['${country}']['country_name']}
    Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
    ${header_labels}        Get NAV Headers
    Log      ${yaml_data['${country}']['country_name']} -> ${header_labels}      console=True
    Lists Should Be Equal       ${header_labels}        ${yaml_data['${country}']['headers']}       ignore_order=True


Change Country And Go To Investments
    [Arguments]     ${country}
    Run Keyword And Continue On Failure     Open Profile Preferences
    Run Keyword And Continue On Failure     Change UX Country     ${yaml_data['${country}']['country_name']}

    Log    ${EMPTY}    console=True
    Log      *** ${yaml_data['${country}']['country_name']} ***    console=True

    Click      ${HomePage_Links_Investments}

*** Test Cases ***

Check Header For All Countries
    [Tags]         REGRESSION       CLIENTCOUNTRIES        DAILYRUN
    [Documentation]  Verify header and footer labels for different countries.
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CLIENT_SITE_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin15}     firstime=False
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    Run Keyword And Continue On Failure     Open Profile Preferences
    IF      '${ctry_flag}'=='ALL'
            FOR     ${country_code}    IN      @{yaml_data}
                Run Keyword And Continue On Failure     Ensure Header Labels Match For Given Country        ${country_code}
            END
    ELSE
        Ensure Header Labels Match For Given Country        ${ctry_flag}
    END


Check Client Site Random Fund Documents
    [Tags]             REGRESSION    CLIENTCOUNTRIES    LONGRUNNING
    [Documentation]    Verify fund document links for random portfolios.
    ...                NOTE: Random document titles and their links are being validated in this test.
    Set To Dictionary    ${browser_opt}    args=["--disable-web-security"]
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${CLIENT_SITE_URL}/login
    Make Client Site Login      user=${ClientSite_GenericLogin16}     firstime=False
    Run Keyword And Continue On Failure     Set Country To USA If Not Already
    IF      '${ctry_flag}'=='ALL'
            FOR     ${country_code}    IN      @{yaml_data}
                    Run Keyword And Continue On Failure    Change Country And Go To Investments     ${country_code}
                    Run Keyword And Continue On Failure    Check Fund Centre Documents
            END
    ELSE
        Run Keyword And Continue On Failure    Change Country And Go To Investments     ${ctry_flag}
        Run Keyword And Continue On Failure    Check Fund Centre Documents
    END


Check Client Site Specific Fund Documents
    [Tags]             REGRESSION    CLIENTCOUNTRIES    LONGRUNNING    DAILYRUN
    [Documentation]    Verify fund documents for specific funds in the countries 'US','CA','UK','AU','IE'.
    ...                If the tag REGRESSION is used, specific document titles only will be validated in this test. No links will be validated.
    ...                If any other tag is used or if no tag is used, specific document titles and specific document links will be validated.
    Set To Dictionary    ${browser_opt}    args=["--disable-web-security"]
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${CLIENT_SITE_URL}/login
    Make Client Site Login    user=${ClientSite_GenericLogin17}    firstime=False

    IF  '${ctry_flag}'=='ALL'
        FOR  ${country_code}  IN  @{yaml_data}
            IF  '${country_code}' in ['US','CA','UK','AU','IE']
                Run Keyword And Continue On Failure    Change Country And Go To Investments    ${country_code}
                Run Keyword And Continue On Failure    Check Client Site Fund Documents   ${country_code}
            END
        END
    ELSE
        Run Keyword And Continue On Failure    Change Country And Go To Investments    ${ctry_flag}
        Run Keyword And Continue On Failure    Check Client Site Fund Documents   ${ctry_flag}
    END
