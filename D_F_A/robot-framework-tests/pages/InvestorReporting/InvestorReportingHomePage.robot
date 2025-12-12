*** Variables ***

${InvestorReportingHomePage_Button_AccountSetupMenu}    a#AccountSetupMenuItem
${InvestorReportingHomePage_Values_SRTable}             tr.odd > td, tr.even>td

*** Keywords ***

Ensure Data Appears In Status Report Grid
    [Documentation]     Check Status Report Grid on Home Page
    Run Keyword And Continue On Failure     Ensure Data Appears In Grid     ${InvestorReportingHomePage_Values_SRTable}