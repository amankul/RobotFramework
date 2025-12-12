*** Variables ***

${ToolsPage_Link_RetirementCalculator}    [data-qa="landing-page-content-tertiary-title"] >> "Retirement Income Calculator"
${ToolsPage_Button_Calculate}             "Calculate"

*** Keywords ***
Open and Verify Retirement Income Calculator
    Run Keyword And Continue On Failure     Wait For Elements State         ${ToolsPage_Link_RetirementCalculator}        state=stable    timeout=60s
    Evaluate Javascript         ${ToolsPage_Link_RetirementCalculator}         (elem) => elem.click()
    Run Keyword And Continue On Failure     Wait For Elements State         ${ToolsPage_Button_Calculate}     detached        timeout=60s
    Get Title         ==        Retirement Income Calculator

