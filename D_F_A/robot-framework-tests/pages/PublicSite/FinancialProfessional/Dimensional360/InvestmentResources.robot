

*** Variables ***
${InvestmentResources_Container_OneToOneColumn}               .one-to-one-column-container


*** Keywords ***
Verify One-To-One Column Container & Image
    ${containers}        Get Elements     ${InvestmentResources_Container_OneToOneColumn}
    ${container}         Get From List    ${containers}    0
    Run Keyword And Continue On Failure    Get Classes    ${container} >> .one-to-one-column-left > :first-child    !=    ${EMPTY}
    ${image}        Get Element    ${container} >> .one-to-one-column-right >> img
    Run Keyword And Continue On Failure    Get Attribute    ${image}       src    !=    ${EMPTY}
    Get Attribute    ${image}       alt    !=    ${EMPTY}
