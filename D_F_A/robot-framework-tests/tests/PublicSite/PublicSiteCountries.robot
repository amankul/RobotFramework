*** Settings ***
Resource       ../../env/${environment}.resource
Resource       ../../pages/GlobalKeywords.robot
Resource       ../../pages/GlobalVariables.robot
Resource       ../../pages/PublicSite/FinancialProfessional/DocumentCenterPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/HomePage.robot
Resource       ../../pages/PublicSite/IndividualInvestor/HomePage.robot
Resource       ../../pages/PublicSite/SplashPage.robot
Resource       ../../pages/PublicSite/SiteResiliencyPage.robot
Suite Setup    Run Keywords    Get-Credentials    Get Yaml Data
Test Setup     Initialize Browser
Test Timeout       30 minutes

*** Keywords ***
Get Yaml Data
    ${yaml_data}        Load Yaml       robot-framework-tests/env/publiccountryconfig.yml
    Set Suite Variable      ${yaml_data}


Switch Audience
    [Arguments]     ${audience}
    [Documentation]     Switch the audience on the page.
    Scroll To    vertical=top
    Run Keyword And Continue On Failure    Click    ${IndHomePage_Button_AudienceSwitchCTA}
    ${aud}    Replace String      ${SplashPage_Button_AudienceType}    PLACEHOLDER+AUDIENCE    ${audience}
    Wait For Condition    Element States    ${SplashPage_Link_LocationChange}    contains    visible
    ${states}    Get Element States    ${aud}
    ${audience_state}    Evaluate    'visible' in ${states}

    IF  ${audience_state} == True
        Select Audience    ${audience}
    ELSE
        Log    The audience ${audience} is not available for the selected country.    console=True
    END
    RETURN    ${audience_state}


Verify Header Links
    Log    Verifying Headers    console=True
    Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True
    ${all_headers}    Get Elements    ${HomePage_Label_Header}
    FOR  ${header}  IN  @{all_headers}
        Wait For Load State    networkidle    timeout=5s
        ${subheader_dropdown}    Get Element States    ${header} >> ${HomePage_Container_Sub-header}
        IF  "attached" in @{subheader_dropdown}
            ${sub_header_links}    Get Elements    ${header} >> ${HomePage_Container_Sub-header} >> ${HomePage_Links_Header}
            FOR    ${slink}    IN    @{sub_header_links}
                Run Keyword And Continue On Failure    Click    ${header}
                ${link}    Get Attribute    ${slink}    href
                ${link_text}    Get Property    ${slink}    innerText
                Log    ${link_text} : ${link}    console=True

                ${Current_Page}    Get Page Ids    CURRENT
                Run Keyword And Continue On Failure    Click    ${slink}
                Run Keyword And Continue On Failure    Get Title    validate    value not in ["Page not found", ${None}, ${EMPTY}]

                IF  ('careers' in '${link}' and '採用情報' in '${link_text}')
                    Run Keyword And Continue On Failure    Go Back
                ELSE
                    Run Keyword And Continue On Failure    Switch Page    ${Current_Page}[0]
                END
            END
        ELSE
            ${hlink}    Get Attribute    ${header} >> ${HomePage_Links_Header}    href
            ${hlink_text}    Get Property    ${header} >> ${HomePage_Links_Header}    innerText
            Log    ${hlink_text} : ${hlink}    console=True
            Run Keyword And Continue On Failure    Click    ${header} >> ${HomePage_Links_Header}
            Run Keyword And Continue On Failure    Get Title    validate    value not in ["Page not found", ${None}, ${EMPTY}]
        END
    END


Check Headers and Footers
    [Arguments]    ${country}
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${yaml_data['${country}']['country_language']}/who-we-are/about-us

    Log    =====================================================================================================================================================    console=True
    Log    ${yaml_data['${country}']['country_name']}    console=True
    Log    =====================================================================================================================================================    console=True

    IF  '${country}' in ['HK', 'JP']
        Affirm For Professionals
    ELSE
        Select Audience    professional
    END

    Wait For Load State    networkidle    timeout=100s
    Run Keyword And Continue On Failure    Reload

    Run Keyword And Continue On Failure    Check Professional Audience Navigation Links    headers
    Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True

    Run Keyword And Continue On Failure    Check Professional Audience Navigation Links    footers
    Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True

    ${aud_state}    Run Keyword And Continue On Failure    Switch Audience    individual
    Wait For Load State    networkidle    timeout=100s
    Run Keyword And Continue On Failure    Reload

    Run Keyword And Continue On Failure    Run Keyword If    ${aud_state} == True    Check Individual Audience Navigation Links    headers
    Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True

    Run Keyword And Continue On Failure    Run Keyword If    ${aud_state} == True    Check Individual Audience Navigation Links    footers
    Close Browser

Verify Given HA Site
    [Arguments]    ${ha_url}
    Set To Dictionary        ${context_opt}       ignoreHTTPSErrors=True
    Run Keyword And Continue On Failure    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${ha_url}
    Run Keyword And Continue On Failure    Check Funds Info For Countries
    Run Keyword And Continue On Failure    Check Regulatory Documents and Disclosures
    Run Keyword And Continue On Failure    Close Browser


*** Test Cases ***
Check Public Site Specific Fund Documents
    [Tags]             REGRESSION    PUBLICCOUNTRIES    SERVERSAT    DAILYRUN
    [Documentation]    Verify # of fund documents for a portfolios in yaml configuration.
    ...                NOTE - UK argument will test global document center.
    ...                Specific document titles are being validated in this test. No links are validated.

    IF      '${ctry_flag}'=='ALL'
            FOR     ${country_code}    IN      @{yaml_data}
                    Run Keyword If      '${country_code}' in ['US','CA','AU','IE','UK']     Check Fund Documents     ${country_code}
                    Close Browser
            END
    ELSE
        Check Fund Documents     ${ctry_flag}
    END


Verify Backup Fund Center Sites
    [Tags]             DAILYRUN
    [Documentation]    Verify as of date and regulatory links for funds of all countries listed on resiliency sites(info and info2)
    [Template]    Verify Given HA Site
    ${HA_SITE_URL}
    ${HA_SITE_URL2}


Verify Public Site Headers and Footers
    [Tags]             REGRESSION    PUBLICCOUNTRIES    DAILYRUN    LONGRUNNING
    [Documentation]    Verify header and footer links for professional and individual audience across all countries.
    Set To Dictionary    ${browser_opt}    args=["--disable-web-security"]
    Set To Dictionary    ${context_opt}    viewport={'width': 1440, 'height': 800}
    # Hardcoding to execute in chromium as firefox (nightly) is causing a lot of lagging issues resulting in intermittent failures.
    Run Keyword If      '${browser}'=='firefox'     Set To Dictionary        ${browser_opt}       browser=chromium
    IF  '${ctry_flag}'=='ALL'
        FOR  ${country_code}  IN  @{yaml_data}
            IF  '${country_code}' in ['AU', 'CA', 'CA-FR', 'DE', 'HK', 'IE', 'JP', 'NL', 'SG', 'UK', 'US']
                Run Keyword And Continue On Failure    Check Headers and Footers    ${country_code}
            END
        END
    ELSE
        Check Headers and Footers    ${ctry_flag}
    END


Verify Public Site Fund Assets
    [Tags]             REGRESSION    PUBLICCOUNTRIES    DAILYRUN
    [Documentation]    Check that the fund document asset names and ids, for countries that support translations, match across countries.
    @{failed_portfolios}    Create List
    IF  '${ctry_flag}'=='ALL'
        FOR  ${country_code}  IN  @{yaml_data}
            IF  '${country_code}' in ['CA', 'CA-FR', 'UK', 'DE', 'NL']
                ${failed_funds}    Run Keyword And Continue On Failure    Check Fund Assets    ${country_code}
                Run Keyword And Continue On Failure    Append To List    ${failed_portfolios}    ${failed_funds}
            END
        END
    ELSE
        ${failed_funds}    Run Keyword And Continue On Failure    Check Fund Assets    ${ctry_flag}
        Run Keyword And Continue On Failure    Append To List    ${failed_portfolios}    ${failed_funds}
    END
    Run Keyword If    len(${failed_portfolios}) != 0    Log    Asset IDs do not match for the following portfolios ${failed_portfolios}    console=True