##This is page object of insights page copied to dev-lab/qa-test-pages/insights

*** Variables ***
${InsightsPage_Featured_SingleCard}    .insight-featured-type
${InsightsPage_Featured_Main}          [class*="insights-featured-media"]
${InsightsPage_Featured_Topic}         .insights-featured-label
${InsightsPage_Featured_Title}         .insights-featured-title
${InsightsPage_Featured_Desc}          .insights-featured-description>p
${InsightsPage_Featured_CTA}           .insights-featured-button

*** Keywords ***

Verify Main Image or Video
    IF    "${environment}" == "production"
          Run Keyword And Continue On Failure    Get Attribute    ${InsightsPage_Featured_Main}>*:first-child    data-a-comp    equals    Primary Feature Content Area
          Run Keyword And Continue On Failure     Get Attribute    ${InsightsPage_Featured_Main} >> img    src    !=    ${EMPTY}
          Get Classes      ${InsightsPage_Featured_Main}    validate    any("right" in v for v in value)
          # Check Navigation To Valid Content        ${InsightsPage_Featured_Main}>*:first-child (uncomment after DDXP-10752)
    ELSE
          Run Keyword And Continue On Failure     Get Attribute    ${InsightsPage_Featured_Main} >> video    poster    validate    any(v in value for v in @{Image_Extensions})
          Run Keyword And Continue On Failure     Wait For Condition     Property    ${InsightsPage_Featured_Main} >> video    src    contains     d.com
          Get Classes      ${InsightsPage_Featured_Main}    validate    any("left" in v for v in value)
    END

Verify Article Area
    Run Keyword And Continue On Failure    Get Text         ${InsightsPage_Featured_Topic}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style         ${InsightsPage_Featured_Topic}    color    validate    value in ['${CoolGray900}','${Blue01}']
    Run Keyword And Continue On Failure    Get Style         ${InsightsPage_Featured_Title}    font-family    contains    Sentinel
    Run Keyword And Continue On Failure    Run Keyword If    "${environment}" == "production"    Get Text         ${InsightsPage_Featured_Title}>a    !=    ${EMPTY}
    ...    ELSE    Get Text         ${InsightsPage_Featured_Title}>a    contains    ${QA_Test_Characterset}
    Run Keyword And Continue On Failure    Get Style         ${InsightsPage_Featured_Desc}    color    ==    ${CoolGray1200}
    Run Keyword And Continue On Failure    Get Text         ${InsightsPage_Featured_Desc}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${InsightsPage_Featured_CTA}>a    data-a-linktype    equals    featured
    Check Navigation To Valid Content        ${InsightsPage_Featured_CTA}>a