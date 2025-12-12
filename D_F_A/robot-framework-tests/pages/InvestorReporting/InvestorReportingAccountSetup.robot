*** Variables ***
${InvestorReportingAccount_Values_Table}          tr.odd > td, tr.even>td
${InvestorReportingAccount_Button_Edit}           button.editButton
${InvestorReportingSetup_Button_Exit}             button#exitButton
${InvestorReportingSetup_Dropdown_ReportGroup}    *#reportGroupSelect

*** Keywords ***

Ensure Data Appears In Account Setup Grid
    Run Keyword And Continue On Failure     Ensure Data Appears In Grid     ${InvestorReportingAccount_Values_Table}

Confirm Setup Detail Page
    @{accounts}       Get Elements     ${InvestorReportingAccount_Button_Edit}
    ${random_account_edit}     Evaluate  random.choice($accounts)
    Run Keyword And Continue On Failure     Click        ${random_account_edit}
    Get Select Options     ${InvestorReportingSetup_Dropdown_ReportGroup}    validate   any(v["label"] == "Balanced SMA" for v in value)
    Run Keyword And Continue On Failure     Click        ${InvestorReportingSetup_Button_Exit}
