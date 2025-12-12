# This is a page object for Careers Home Page.

*** Variables ***
${CareersPage_Link_Internships}        .simple-public-nav-container >> [data-a-name="Internships"]
${CareersPage_Button_Apply}            [data-a-name="Apply now"]
${CareersPage_Button_Professionals}    .simple-public-nav-container >> [data-a-name="Explore Opportunities"]
${Workday_TextBox_Search4Jobs}         [data-automation-id="keywordSearchInput"]

*** Keywords ***

Navigate To Active Openings
    [Arguments]        ${opening_type}
    [Documentation]    Verify active openings can be seen on workday
    Log To console    Checking workday redirect for ${opening_type}
    IF  '${opening_type}' == 'Internships'
        Run Keyword And Continue On Failure    Click    ${CareersPage_Link_Internships}
        Run Keyword And Continue On Failure    Click    ${CareersPage_Button_Apply}
        Switch Page      NEW
        Wait For Load State    networkidle
        Run Keyword And Continue On Failure    Get Element States    ${Workday_TextBox_Search4Jobs}    contains    visible    attached
        ${url}    Get Url
        Run Keyword And Continue On Failure    Should Match    ${url}    *${CareerOpenings_Host}*${CareerOpenings_Careers_Param}${CareerOpenings_Internships_Param}
    ELSE IF  '${opening_type}' == 'Professionals'
        Run Keyword And Continue On Failure    Click    ${CareersPage_Button_Professionals}
        Switch Page      NEW
        Wait For Load State    networkidle
        Run Keyword And Continue On Failure    Get Element States    ${Workday_TextBox_Search4Jobs}    contains    visible    attached
        ${url}    Get Url
        Run Keyword And Continue On Failure    Should Match    ${url}    *${CareerOpenings_Host}*${CareerOpenings_Careers_Param}
    END
    Go To    ${CAREERS_URL}
