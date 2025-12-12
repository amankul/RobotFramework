*** Variables ***
${FoundationsOfInvestingPage_Container_Billboard}    .billboard-container
${FoundationsOfInvestingPage_Container_ContentBlock}    .content-block-container

*** Keywords ***
Verify Billboard Container Attributes
    ${containers}    Get Elements     ${FoundationsOfInvestingPage_Container_Billboard}
    Run Keyword And Continue On Failure    Run Keyword If    '${environment}' != 'production'    Get Style    ${containers}[0]    background-color    should not be    ${White}
    Run Keyword And Continue On Failure    Get Style    ${containers}[1]    background-color    should be    ${White}
    Run Keyword And Continue On Failure    Get Classes    ${containers}[1]    contains    billboard-row-reverse-xs
    Run Keyword And Continue On Failure    Get Classes    ${containers}[1] >> .billboard-left > div    !=    ${EMPTY}
    Get Classes    ${containers}[1] >> .billboard-right > div    !=    ${EMPTY}


Check Content Block Container
    IF    '${environment}' == 'production'
        ${block_containers}    Get Elements    ${FoundationsOfInvestingPage_Container_ContentBlock}
        ${FoundationsOfInvestingPage_Container_ContentBlock}    Set Variable       ${block_containers}[0]
        Run Keyword And Continue On Failure    Get Style    ${FoundationsOfInvestingPage_Container_ContentBlock}    background-color    ==    ${WarmGray06}
    ELSE
        Run Keyword And Continue On Failure    Get Style    ${FoundationsOfInvestingPage_Container_ContentBlock}    background-color    ==    ${White}
        Run Keyword And Continue On Failure    Get Text    ${FoundationsOfInvestingPage_Container_ContentBlock} >> h2    ==       ${QA_Test_Characterset}
    END
    Run Keyword And Continue On Failure    Get Text    ${FoundationsOfInvestingPage_Container_ContentBlock} >> div.content-block-container-title > span    !=       ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${FoundationsOfInvestingPage_Container_ContentBlock} >> div.content-block-container-title > span > span   contains    t-label-md-heavy
    Run Keyword And Continue On Failure    Get Style    ${FoundationsOfInvestingPage_Container_ContentBlock} >> div.content-block-container-divider     border-bottom-color   ==    ${WarmGray04}

    ${links}    Get Elements    ${FoundationsOfInvestingPage_Container_ContentBlock} >> .rtf-container > p
    FOR    ${link}    IN    @{links}
        Run Keyword And Continue On Failure    Get Attribute    ${link} >> a    href    !=       ${EMPTY}
        Run Keyword And Continue On Failure    Get Style    ${link} >> a    color    equals    ${Teal900}
        Run Keyword And Continue On Failure    Get Style    ${link} >> a    display    equals    block    pseudo_element=::after
        Run Keyword And Continue On Failure    Hover       ${link} >> a
        Run Keyword And Continue On Failure    Get Style    ${link} >> a    text-decoration-line    equals    underline
    END