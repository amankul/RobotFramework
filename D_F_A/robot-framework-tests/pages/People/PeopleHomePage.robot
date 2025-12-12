
*** Variables ***
${PeopleHomePage_TextBox_Search}            \#pSearchInput
${PeopleHomePage_Button_Search}             \#pSearchBtn
${PeopleHomePage_HeaderName_FirstInList}    \#name_0
${PeopleHomePage_Header_Expand}             div.bioHeader
${PeopleHomePage_Tab_Standard}              \#pBioStndrdL
${PeopleHomePage_Tab_Quotes}                \#pBioQuotesL
${PeopleHomePage_TextArea_Standard}         \#stndrdBioTxt
${PeopleHomePage_Btn_SelectLanguage}        \#languageBtn


*** Keywords ***

Search Executive
    [Arguments]    ${exec}
    [Documentation]    Verify given executive can be searched
    Fill Text       ${PeopleHomePage_TextBox_Search}        ${exec}
    Click       ${PeopleHomePage_Button_Search}
    Get Text        ${PeopleHomePage_HeaderName_FirstInList}        *=      ${exec}         message="Executive ${exec} not found"

Verify Quote in Bio and Languages
    [Arguments]    ${bio}     ${language}
    [Documentation]    Verify executive bio contains standard and quotes. Also verify languages selection.
    Click     ${PeopleHomePage_Header_Expand}
    Wait For Elements State     ${PeopleHomePage_Tab_Standard}
    Click     ${PeopleHomePage_Btn_SelectLanguage}
    Click       css=[id*="${language}"]
    Get Text        ${PeopleHomePage_TextArea_Standard}        *=      ${bio}
    Click     ${PeopleHomePage_Tab_Quotes}
