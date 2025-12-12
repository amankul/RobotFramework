*** Variables ***
${JenkinsLogin_Text_Username}        \#j_username
${JenkinsLogin_Text_Password}        \#j_password
${JenkinsLogin_Button_Submit}        [type="submit"]
${JenkinsJobPage_Link_LastBuild}     "Today" >> ../.. >> div:first-of-type > a.app-builds-container__item__icon
${JenkinsJobPage_Heading_Title}      .page-headline

*** Keywords ***

Check Latest Jenkins Run
    [Arguments]        ${job_name}
    Run Keyword And Continue On Failure     Wait For Condition    Text        ${JenkinsJobPage_Heading_Title}    *=    ${job_name}    timeout=2min
    Run Keyword And Continue On Failure     Get Attribute    ${JenkinsJobPage_Link_LastBuild}     title     ==    Success
