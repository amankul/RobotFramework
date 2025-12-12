# This is page object for "us-en/dev-lab/qa-test-pages/our-approach"

*** Variables ***
${OurApproachPage_Div_Donut3}                          .animated-donut
${OurApproachPage_Box_Donut3}                          .animated-donut-cards
${OurApproachPage_Text_Donut3Disc}                     .animated-donuts-disclosure
${OurApproachPage_TooltipWindow_Donut3}                [data-qa="d-tooltip-window"]
${OurApproachPage_Container_ColumnCards}               [data-view="column-card-container"]
${OurApproachPage_Container_ColumnCardLabel}           .column-card-label-container
${OurApproachPage_Text_ColumnCardLabel}                .column-card-label
${OurApproachPage_Text_ColumnCardTitle}                .column-card-title
${OurApproachPage_Image_ColumnCard}                    .column-card-image
${OurApproachPage_Text_ColumnCardDescription}          .column-card-description
${OurApproachPage_Button_ColumnCard}                   [data-qa="column-card-cta-button"]
@{OurApproachPage_Colors_ColumnCardAccentbar}          ${Teal05}    ${Teal04}    ${Teal01}    ${Green02}
${OurApproachPage_Text_ExtendedCardTitle}              .extended-card-carousel-text-title
${OurApproachPage_Container_ExtendedCardCarousel}      .extended-card-carousel-container
${OurApproachPage_Container_ExtendedCard}              .extended-card-container
${OurApproachPage_Button_ExtendedCardToggle}           [data-qa="extended-card-carousel-view-toggle"]
${OurApproachPage_Button_ExtendedCardScrollLeft}       [data-qa="extended-card-carousel-text-btn-container-arrows-left"]
${OurApproachPage_Button_ExtendedCardScrollRight}      [data-qa="extended-card-carousel-text-btn-container-arrows-right"]
${OurApproachPage_Div_ExtendedCards}                   .extended-card-section:first-child >> .extended-card

*** Keywords ***
Verify Disclosure and Tooltip Donut3
    Run Keyword And Continue On Failure    Get Text    ${OurApproachPage_Text_Donut3Disc} >> span   !=    ${EMPTY}
    Click    ${OurApproachPage_Box_Donut3} >> [data-qa="d-icon-information-expressive"]
    Run Keyword And Continue On Failure    Wait For Load State
    Get Element States    ${OurApproachPage_TooltipWindow_Donut3}       not contains        hidden
    Run Keyword And Continue On Failure    Get Text   ${OurApproachPage_TooltipWindow_Donut3}     !=    ${EMPTY}


Check Animated Donut Title, Description and Percentages Donut3
    Run Keyword And Continue On Failure    Hover     ${OurApproachPage_Box_Donut3}              # to scroll and load animations
    ${donuts}        Get Elements        ${OurApproachPage_Div_Donut3}
    FOR    ${index}    ${donut}    IN ENUMERATE   @{donuts}
        Run Keyword And Continue On Failure    Get Text    ${donut} >> .animated-donut-title   !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Style    ${donut} >> .animated-donut-title   color     ==    ${CoolGray01}
        IF    ${index} == 0
            Run Keyword And Continue On Failure   Get Attribute    ${donut} >> img     src      !=    ${EMPTY}
            Run Keyword And Continue On Failure    Get Classes     ${donut} >> .donut-description    contains     t-body-xs
            Run Keyword If    "${environment}" == "production"    Run Keyword And Continue On Failure    Get Text    ${donut} >> .donut-description   !=    ${EMPTY}
            ...    ELSE        Run Keyword And Continue On Failure    Get Text    ${donut} >> .donut-description   contains    ${QA_Test_Characterset}
        ELSE
            Run Keyword And Continue On Failure    Get Text    ${donut} >> .animated-donut-inner-text-percentage    matches    ^([0-9]|[1-9][0-9])%$
            Wait For Condition     attribute   ${donut} >> .animated-donut-percent-teal    style    contains      conic-gradient(from 0deg, #038189
        END
    END


Check Column Card Container Label and Arrow
    Run Keyword And Continue On Failure    Scroll To Element    ${OurApproachPage_Container_ColumnCards}
    Run Keyword And Continue On Failure    Get Element States    ${OurApproachPage_Text_ColumnCardLabel}    contains    visible
    Run Keyword And Continue On Failure    Get Style    ${OurApproachPage_Text_ColumnCardLabel}    color    ==    ${WarmGray01}
    Run Keyword And Continue On Failure    Get Classes    ${OurApproachPage_Text_ColumnCardLabel}    contains    t-label-sm-heavy
    Run Keyword And Continue On Failure    Get Text    ${OurApproachPage_Text_ColumnCardLabel}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${OurApproachPage_Container_ColumnCardLabel} >> img    src    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${OurApproachPage_Container_ColumnCardLabel} >> img    alt    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Set Viewport Size    width=1024    height=800
    Run Keyword And Continue On Failure    Get Element States    ${OurApproachPage_Container_ColumnCardLabel}    contains    hidden


Check Column Card Accent Bar, Title and Image
    [Arguments]    ${index}    ${card}
    Run Keyword And Continue On Failure    Get Style    ${card}    background-color    equals    ${OurApproachPage_Colors_ColumnCardAccentbar}[${index}]    pseudo_element=:before
    Run Keyword And Continue On Failure    Get Text    ${card} >> ${OurApproachPage_Text_ColumnCardTitle}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${card} >> ${OurApproachPage_Text_ColumnCardTitle}    contains    t-heading-lg
    Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurApproachPage_Image_ColumnCard}    src    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurApproachPage_Image_ColumnCard}    alt    !=    ${EMPTY}


Check Column Card Description and CTA
    [Arguments]    ${index}    ${card}
    Run Keyword And Continue On Failure    Get Classes    ${card} >> ${OurApproachPage_Text_ColumnCardDescription}    contains    t-body-sm

    IF  '${environment}' == 'production'
        Run Keyword And Continue On Failure    Get Text    ${card} >> ${OurApproachPage_Text_ColumnCardDescription}    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Text    ${card} >> ${OurApproachPage_Button_ColumnCard}    !=    ${EMPTY}
    ELSE
        Run Keyword And Continue On Failure    Get Text    ${card} >> ${OurApproachPage_Text_ColumnCardDescription}    contains    ${QA_Test_Characterset}
        Run Keyword And Continue On Failure    Get Text    ${card} >> ${OurApproachPage_Button_ColumnCard}    contains    ${QA_Test_Characterset}[:-9]
    END

    IF  ${index} < 3
        Run Keyword And Continue On Failure    Get Style    ${card} >> ${OurApproachPage_Button_ColumnCard}    background-color    equals    ${Teal02}
    ELSE
        Run Keyword And Continue On Failure    Get Style    ${card} >> ${OurApproachPage_Button_ColumnCard}    background-color    equals    ${Green01}
    END

    Run Keyword And Continue On Failure    Get Classes    ${card} >> ${OurApproachPage_Button_ColumnCard}    contains    t-label-xs-heavy
    ${link}    Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurApproachPage_Button_ColumnCard}    href    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurApproachPage_Button_ColumnCard}    data-a-evt    equals    Link Click
    Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurApproachPage_Button_ColumnCard}    data-a-comp    equals    Column Card Container
    Run Keyword And Continue On Failure    Click    ${card} >> ${OurApproachPage_Button_ColumnCard}
    Run Keyword And Continue On Failure    Wait For Condition    Url    equals    ${link}
    Go Back


Check Column Cards
    Run Keyword And Continue On Failure    Check Column Card Container Label and Arrow
    ${cards}    Get Elements    ${OurApproachPage_Container_ColumnCards} >> .column-card
    FOR    ${index}    ${card}    IN ENUMERATE    @{cards}
        Run Keyword And Continue On Failure    Check Column Card Accent Bar, Title and Image    ${index}    ${card}
        Run Keyword And Continue On Failure    Check Column Card Description and CTA    ${index}    ${card}
    END

Verify Title and Background Image For Extended Card
    Run Keyword And Continue On Failure    Get Classes    ${OurApproachPage_Text_ExtendedCardTitle}    contains     t-heading-xl
    Run Keyword And Continue On Failure    Run Keyword If    "${environment}" == "production"    Get Text    ${OurApproachPage_Text_ExtendedCardTitle}     !=     ${EMPTY}
    ...    ELSE        Run Keyword And Continue On Failure    Get Text    ${OurApproachPage_Text_ExtendedCardTitle}     contains    ${QA_Test_Characterset}
    Get Style     ${OurApproachPage_Container_ExtendedCardCarousel}     background-image    !=    ${EMPTY}


Verify Toggle and Scroll
    ${cards}    Get Elements     ${OurApproachPage_Div_ExtendedCards}
    Set Test Variable    ${cards}
    ${toggle_viewall}    ${height_viewall}    Run Keyword And Continue On Failure    Check Toggle and Scroll Buttons    viewall
    Run Keyword And Continue On Failure    Click    ${OurApproachPage_Button_ExtendedCardToggle}
    Run Keyword And Continue On Failure    Get Style     ${OurApproachPage_Button_ExtendedCardToggle}     color    ==     ${Teal05}
    Run Keyword And Continue On Failure    Scroll By    vertical=50
    ${toggle_collapse}    ${height_collapse}    Run Keyword And Continue On Failure    Check Toggle and Scroll Buttons    collapse
    Run Keyword And Continue On Failure    Run Keyword If    "${environment}" == "production"    Should Not Be Equal    ${height_viewall}    !=     ${height_collapse}
    ...    ELSE        Run Keyword And Continue On Failure    Should Be True    ${height_viewall.strip('px')}-${height_collapse.strip('px')} > 200
    Run Keyword And Continue On Failure   Should Not Be Equal         ${toggle_viewall}    ${toggle_collapse}
    Run Keyword And Continue On Failure   Click    ${OurApproachPage_Button_ExtendedCardToggle}
    Run Keyword And Continue On Failure   Wait For Condition    Style    ${OurApproachPage_Container_ExtendedCard}    grid-auto-flow    ==    column
    Run Keyword And Continue On Failure   Get Attribute    ${OurApproachPage_Container_ExtendedCard}    data-index    ==    0

Check Toggle and Scroll Buttons
    [Arguments]    ${toggle}
    Wait For Load State    networkidle
    Run Keyword And Continue On Failure    Get Style      ${OurApproachPage_Button_ExtendedCardToggle}     color    ==    ${WHITE}
    Run Keyword And Continue On Failure    Get Style      ${OurApproachPage_Button_ExtendedCardToggle}     border-bottom    contains    solid
    Run Keyword And Continue On Failure    Get Attribute    ${OurApproachPage_Button_ExtendedCardToggle}    data-a-comp    equals      Extended Card Carousel
    Run Keyword And Continue On Failure   Get Element States    ${OurApproachPage_Button_ExtendedCardScrollLeft}     contains     disabled
    IF    "${toggle}" == "viewall"
        Run Keyword And Continue On Failure   Get Element States    ${OurApproachPage_Button_ExtendedCardScrollRight}    contains     enabled
        Run Keyword And Continue On Failure    Get Attribute    ${OurApproachPage_Button_ExtendedCardScrollRight}    data-a-comp    equals      Extended Card Carousel
        Run Keyword And Continue On Failure   Get Attribute    ${OurApproachPage_Container_ExtendedCard}    data-index    ==    0
        Run Keyword And Continue On Failure   Click    ${OurApproachPage_Button_ExtendedCardScrollRight}
        Run Keyword And Continue On Failure   Get Style     ${OurApproachPage_Button_ExtendedCardScrollRight} >> path:first-child     fill    ==     ${Teal05}
        Run Keyword And Continue On Failure    Get Attribute    ${OurApproachPage_Button_ExtendedCardScrollLeft}    data-a-comp    equals      Extended Card Carousel
        Wait For Elements State    ${OurApproachPage_Button_ExtendedCardScrollLeft}     enabled
        Run Keyword And Continue On Failure   Get Attribute    ${OurApproachPage_Container_ExtendedCard}    data-index    ==    1
    ELSE
        Run Keyword And Continue On Failure   Get Element States    ${OurApproachPage_Button_ExtendedCardScrollRight}    contains     disabled
    END
    ${toggle_text}    Run Keyword And Continue On Failure   Get Text   ${OurApproachPage_Button_ExtendedCardToggle}    !=     ${EMPTY}
    ${card_height}    Run Keyword And Continue On Failure   Get Style    ${cards}[1]    height
    RETURN    ${toggle_text}    ${card_height}


Verify Individual Extended Cards
    FOR    ${index}    ${card}    IN ENUMERATE    @{cards}
        Run Keyword And Continue On Failure    Get Classes    ${card} >> .extended-card-title-text    contains     tc-cool-gray-01
        Run Keyword And Continue On Failure    Get Style      ${card} >> .extended-card-title-sideburn     background-color    ==    ${Poppy01}
        Run Keyword And Continue On Failure    Get Style      ${card} >> .extended-card-description     color    ==    ${CoolGray01}
        IF    ${index} == 1
            Run Keyword And Continue On Failure    Run Keyword If    "${environment}" == "production"    Run Keywords    Get Text    ${card} >> .extended-card-title-text    !=     ${EMPTY}    AND    Get Text   ${card} >> .extended-card-description    !=     ${EMPTY}
    ...     ELSE        Run Keyword And Continue On Failure    Run Keywords    Get Text    ${card} >> .extended-card-title-text     contains    ${QA_Test_Characterset}    AND    Get Text    ${card} >> .extended-card-description     contains    ${QA_Test_Characterset}
        ELSE
            Run Keyword And Continue On Failure    Verify Tooltip Style and Disclosure    ${card} >> [data-qa="d-tooltip"]
        END
    END