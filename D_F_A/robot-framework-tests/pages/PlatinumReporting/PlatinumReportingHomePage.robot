*** Variables ***

${PlatinumReportingHomePage_Link_DailyTxnReport}           text=Daily Transaction Report
${PlatinumReportingHomePage_Link_InstitutionalExtracts}    text=Institutional Extracts - Sales & Marketing EMEA (London Office) Daily Flows
${PlatinumReportingHomePageDTR_TextBox_VehicleCode}        \#VehicleCode
${PlatinumReportingHomePage_TextBox_NotifyEmail}           \#EmailToNotify
${PlatinumReportingHomePage_Button_Submit}                 [type="submit"]
${PlatinumReportingHomePage_Message_Success}               span.help-block

*** Keywords ***

Run Transaction Reports
    [Documentation]     Ensure daily transaction reports are running  with SEMC Vehicle Code
    Click       ${PlatinumReportingHomePage_Link_DailyTxnReport}
    Take Screenshot
    Run Keyword And Continue On Failure     Get Text        ${PlatinumReportingHomePage_TextBox_NotifyEmail}    *=    d.com
    Fill Text       ${PlatinumReportingHomePageDTR_TextBox_VehicleCode}     ${DailyTransactionReport_VehicleCode}
    Click       ${PlatinumReportingHomePage_Button_Submit}
    Wait Until Keyword Succeeds     10 s        250ms   Verify Report Generation        InvestmentsExtracts

Run Institutional Extracts
    [Documentation]     Ensure institutional extract reports are running
    Click       ${PlatinumReportingHomePage_Link_InstitutionalExtracts}
    Click       ${PlatinumReportingHomePage_Button_Submit}
    ${message}     Get Text        ${PlatinumReportingHomePage_Message_Success}    *=    ${PlatinumReport_EmailSent}
    Log     ${message}      console=True
    Wait Until Keyword Succeeds     10 s        250ms   Verify Report Generation        InstitutionalExtracts

Verify Report Generation
    [Arguments]         ${type}
    [Documentation]     Ensure the generated report on SMB by checking modified timestamp
    ${secs_current}   Get Time    epoch
    ${path}    Catenate    SEPARATOR=${EMPTY}    ${PLATINUM_REPORTING_REPORTFILESERVER}    /${type}/
    ${secs_modified}  Get Modified Time   ${path}     epoch
    ${seconds_diff}     Evaluate    ${secs_current} - ${secs_modified}
    Run Keyword And Continue On Failure     Should Be True        ${seconds_diff} < ${10}
