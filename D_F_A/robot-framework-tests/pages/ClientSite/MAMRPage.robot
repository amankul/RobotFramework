*** Variables ***

${MAMRPage_Tab_MyReports}             [aria-label='Focus My Reports']
${MAMRPage_Rows_MyAccountsGrid}       .mamr-myaccounts-holdings-table-row-body
${MAMRPage_Rows_MyReportsGrid}        .mamr-my-reports-table-row
${MAMRPage_MyAccounts_FundTotals}     .mamr-myaccounts-client-row>div.mamr-myaccounts-table-body-row-totals>ul>li
${MAMRPage_MyAccounts_AccountName}    .mamr-myaccounts-account-row>div.mamr-myaccounts-table-body-row-name
${MAMRPage_Button_DownloadReport}     [aria-label="Download Selected Reports"]
${MAMRPage_Label_ReportType}          //label[text()="Report Type"]
${MAMRPage_Tab_MyAccountsTitle}       .mamr-client-list-header-title


*** Keywords ***

Ensure My Accounts Page Load
    [Documentation]    Verifies my accounts page loads
    Wait For Elements State    ${MAMRPage_Tab_MyAccountsTitle}    visible
    ${total_fund_value}       Get Text    ${MAMRPage_MyAccounts_FundTotals}
    Run Keyword And Continue On Failure     Should be True      ${total_fund_value.strip(' USD').replace(',','')}  > 0.1
    Run Keyword And Continue On Failure     Get Text    ${MAMRPage_MyAccounts_AccountName}     validate        value.strip()
    Get Element Count    ${MAMRPage_Rows_MyAccountsGrid}    >    1


Ensure My Reports Page Load
    [Documentation]    Verifies my reports page loads
    Click       ${MAMRPage_Tab_MyReports}
    Wait For Elements State          ${MAMRPage_Label_ReportType}
    Get Element States      ${MAMRPage_Button_DownloadReport}      contains        disabled
    Wait Until Keyword Succeeds     5 s        500ms       Get Element Count    ${MAMRPage_Rows_MyReportsGrid}    >    0