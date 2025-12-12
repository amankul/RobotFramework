# This is page object for "dev-lab/qa-test-pages/featured-home
*** Variables ***
${FeaturedCMSPage_Div_PrimaryArticle}           [data-qa="home-featured-main-article-title"]
${FeaturedCMSPage_Div_SecondaryContentCards}    [data-qa="home-featured-secondary"]

*** Keywords ***

Check Featured Area Contents & Cards
    [Arguments]         ${featured_main}        ${idx}
    [Documentation]     Click on Primary And Secondary Featured Content
    ${pri_locator}         Catenate          SEPARATOR=      ${featured_main}       >> ${FeaturedCMSPage_Div_PrimaryArticle}
    Run Keyword And Continue On Failure     Check Navigation To Valid Content       ${pri_locator} >> a
    Run Keyword And Continue On Failure     Check Format & Use       ${pri_locator} >> p        ${idx}
    ${secondary_cards}     Get Elements      ${featured_main} >> ${FeaturedCMSPage_Div_SecondaryContentCards}
    FOR    ${card}    IN    @{secondary_cards}
            Run Keyword And Continue On Failure    Check Format & Use    ${card} >> p:first-child    ${idx}
            Run Keyword And Continue On Failure    Check Navigation To Valid Content    ${card}
    END

Check Format & Use
    [Documentation]     Check Format and Use labels of cards are as configured
    [Arguments]         ${locator}      ${flag}
    ${format_use}       Get Text        ${locator}
    Log      ${format_use}     console=True
    @{format_use_array}       Split String      ${format_use}      |
    IF      len($format_use_array) == 2
            Run Keyword And Continue On Failure     Should Contain      ${FeaturedPage_Format_Values}       ${format_use_array[0]}        strip_spaces=True
            Run Keyword And Continue On Failure     Should Contain      ${FeaturedPage_Use_Values}       ${format_use_array[1]}        strip_spaces=True
    ELSE IF      '${flag}'!='2' or '${format_use}' != '${EMPTY}'
        Run Keyword And Continue On Failure     Should Be True      '${format_use.strip()}' in (${FeaturedPage_Format_Values} or ${FeaturedPage_Use_Values})
    END
