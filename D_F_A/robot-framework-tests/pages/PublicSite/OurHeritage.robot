# This is a page object for Our Heritage page: us-en/our-heritage

*** Variables ***
${OurHeritagePage_Button_Years}                    .interactive-timeline-lockscreen-years-btn
${OurHeritagePage_Container_Years}                 .interactive-timeline-years-frame
${OurHeritagePage_Container_CoverCard}             .cover-card-container
${OurHeritagePage_Container_ScrollBar}             .interactive-timeline-lockscreen-scrollbar
${OurHeritagePage_Image_YearFrame}                 .interactive-timeline-year-frame-image
${OurHeritagePage_Container_CoverCardTitle}        .title-anim-card
${OurHeritagePage_Container_CoverCardSubtitle}     .subtitle-anim-card
${OurHeritagePage_Container_YearCard}              .interactive-timeline-card
${OurHeritagePage_Image_YearCard}                  .interactive-timeline-card-image
${OurHeritagePage_Container_YearCardTextBlock}     .interactive-timeline-card-text-block
${OurHeritagePage_Text_YearCardLabel}              .interactive-timeline-card-year
${OurHeritagePage_Text_YearCardCopy}               .interactive-timeline-card-copy
${OurHeritagePage_Text_YearCardSubCopy}            .interactive-timeline-card-sub-copy
${OurHeritagePage_Link_YearCard}                   .interactive-timeline-card-link
${OurHeritagePage_Text_Footnotes}                  .content-page-footnotes
${OurHeritagePage_Container_Disclosure}            .content-page-disclaimer
${OurHeritagePage_Text_Disclosure}                 ${OurHeritagePage_Container_Disclosure} >> .content-page-disclosures-content
${OurHeritagePage_Container_MobileYears}           .interactive-timeline-lockscreen-mobile-container
${OurHeritagePage_Container_MobileScrollBarDot}    .interactive-timeline-lockscreen-mobile-dot
${OurHeritagePage_Button_MobileYears}              .interactive-timeline-lockscreen-mobile-button


*** Keywords ***
Check Timeline Using Scroll And Clicks
    ${timeline_buttons}    Get Elements    ${OurHeritagePage_Button_Years}
    ${year_containers}    Get Elements    ${OurHeritagePage_Container_Years}
    ${total_years}    Get Length    ${timeline_buttons}
    ${cc_container_width}    Get Property    ${OurHeritagePage_Container_CoverCard}    scrollWidth
    ${last_container_width}    Get Property    ${year_containers}[${total_years - 1}]    scrollWidth
    Run Keyword And Continue On Failure    Run Keywords    Set Test Variable    ${timeline_buttons}    AND    Set Test Variable    ${year_containers}

    FOR    ${index}    ${timeline_button}    IN ENUMERATE    @{timeline_buttons}
        ${initial_scrollbar_width}    Run Keyword And Continue On Failure    Get Property    ${OurHeritagePage_Container_ScrollBar}    scrollWidth
        Run Keyword And Continue On Failure    Check Initial States    ${timeline_button} 
        ${year_container_width}    Get Property    ${year_containers}[${index - 1}]    scrollWidth
 
        IF  ${index} == 0
            Run Keyword And Continue On Failure    Scroll By    vertical=${cc_container_width}
            Wait For Page To Stop Scrolling
        ELSE
            Run Keyword And Continue On Failure    Scroll By    vertical=${year_container_width}
            Wait For Page To Stop Scrolling
        END
 
        Run Keyword And Continue On Failure    Check Final States    ${timeline_button}    ${initial_scrollbar_width}    ${index}

        Run Keyword And Continue On Failure    Check Timeline Using Clicks    ${timeline_button}    ${initial_scrollbar_width}    ${index}
        
        # Additional scroll to bring last cards into viewport
        Run Keyword If    ${index} == ${total_years - 1}    Scroll By    vertical=${last_container_width}
    END


Check Timeline Using Clicks
    [Arguments]    ${timeline_button}    ${initial_scrollbar_width}    ${index}
    Run Keyword And Continue On Failure    Scroll To    vertical=top
    Wait For Page To Stop Scrolling

    Run Keyword And Continue On Failure    Click    ${timeline_button}
    Wait For Page To Stop Scrolling

    Run Keyword And Continue On Failure    Check Final States    ${timeline_button}    ${initial_scrollbar_width}    ${index}
    Run Keyword And Continue On Failure    Get BoundingBox    ${year_containers}[${index}] >> ${OurHeritagePage_Image_YearFrame}    x    >    -0.5
    Run Keyword And Continue On Failure    Get Attribute    ${timeline_button}    data-a-comp    equals    Interactive Timeline
    Run Keyword And Continue On Failure    Get Attribute    ${timeline_button}    data-a-evt    equals    Subcontent View


Check Initial States
    [Arguments]    ${timeline_button}
    Run Keyword And Continue On Failure    Get Classes    ${timeline_button}    validate    "active" not in value
    Run Keyword And Continue On Failure    Get Style    ${timeline_button} >> span    color    equals    rgb(110, 120, 127)


Check Final States
    [Arguments]    ${timeline_button}    ${initial_scrollbar_width}    ${index}
    Run Keyword And Continue On Failure    Get Property    ${OurHeritagePage_Container_ScrollBar}    scrollWidth    !=    ${initial_scrollbar_width}
    Run Keyword And Continue On Failure    Wait For Condition    Classes    ${timeline_button}    contains    active
    Run Keyword And Continue On Failure    Get Style    ${timeline_button} >> span    color    equals    rgb(255, 80, 51)

    IF  ${index} > 0
        Mouse Move    0    0
        Run Keyword And Continue On Failure    Get Classes    ${timeline_buttons}[${index - 1}]    validate    "active" not in value
        Run Keyword And Continue On Failure    Get Style    ${timeline_buttons}[${index - 1}] >> span    color    equals    rgb(110, 120, 127)
        Run Keyword And Continue On Failure    Get BoundingBox    ${year_containers}[${index - 1}] >> ${OurHeritagePage_Image_YearFrame}    x    <    0
    ELSE
        Run Keyword And Continue On Failure    Get BoundingBox    ${OurHeritagePage_Container_CoverCardTitle}    x    <    0        
    END


Check Timeline Cover Card
    Run Keyword And Continue On Failure    Get Style    ${OurHeritagePage_Container_CoverCardTitle} >> [class*="accent-bar"]    background-color    equals    rgb(255, 80, 51)
    Run Keyword And Continue On Failure    Get Text    ${OurHeritagePage_Container_CoverCardTitle} >> .rtf-container >> .title    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${OurHeritagePage_Container_CoverCardTitle} >> .rtf-container >> .title    contains    t-title-lg
    Run Keyword And Continue On Failure    Get Style    ${OurHeritagePage_Container_CoverCardTitle}    animation-name    equals    tl-cover-card-title-reveal
 
    Run Keyword And Continue On Failure    Get Text    ${OurHeritagePage_Container_CoverCardSubtitle} >> span    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${OurHeritagePage_Container_CoverCardSubtitle} >> p    contains    t-subtitle
    Run Keyword And Continue On Failure    Get Style    ${OurHeritagePage_Container_CoverCardSubtitle}    animation-name    equals   tl-cover-card-subtitle-move, tl-cover-card-subtitle-fade


Check Timeline Year Cards
    FOR    ${year_index}    ${year}    IN ENUMERATE    @{year_containers}
        Run Keyword And Continue On Failure    Get Attribute    ${year} >> ${OurHeritagePage_Image_YearFrame} >> img    src    !=    ${EMPTY}
        ${frame_year_text}    Run Keyword And Continue On Failure    Get Text    ${timeline_buttons}[${year_index}]
        Run Keyword And Continue On Failure    Get Attribute    ${year} >> ${OurHeritagePage_Image_YearFrame} >> img    alt    equals    Timeline-Decade-${frame_year_text}
 
        ${decade}    Run Keyword And Continue On Failure    Get Text    ${timeline_buttons}[${year_index}]    !=    ${EMPTY}
        ${decade}    Convert To Number    ${decade}
        ${cards}    Get Elements    ${year} >> ${OurHeritagePage_Container_YearCard}
        FOR    ${card_index}    ${card}    IN ENUMERATE    @{cards}
            ${card_year_text}    Run Keyword And Continue On Failure    Get Text    ${card} >> ${OurHeritagePage_Text_YearCardLabel}    !=    ${EMPTY}
            Run Keyword And Continue On Failure    Get Classes    ${card} >> ${OurHeritagePage_Text_YearCardLabel}    contains    t-label-lg-heavy
            Run Keyword And Continue On Failure    Get Style    ${card} >> ${OurHeritagePage_Text_YearCardLabel}    color    equals    rgb(255, 80, 51)
            Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurHeritagePage_Image_YearCard} >> img    src    !=    ${EMPTY}
            Run Keyword And Continue On Failure    Should Be True    ${decade} <= ${card_year_text} and ${card_year_text} < ${decade + 10}

            Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurHeritagePage_Image_YearCard} >> img    alt    contains    ${card_year_text}
            
            Run Keyword And Continue On Failure    Get Text    ${card} >> ${OurHeritagePage_Text_YearCardCopy} > :first-child    !=    ${EMPTY}
            Run Keyword And Continue On Failure    Get Classes    ${card} >> ${OurHeritagePage_Text_YearCardCopy} > :first-child    contains    t-body-sm

            Run Keyword And Continue On Failure    Get Style    ${card} >> ${OurHeritagePage_Image_YearCard}    animation-name    equals   slideInAndFadeIn
            Run Keyword And Continue On Failure    Get Style    ${card} >> ${OurHeritagePage_Container_YearCardTextBlock}    animation-name    equals   slideInAndFadeIn

            ${subtext_state}    Run Keyword And Continue On Failure    Get Element States    ${card} >> ${OurHeritagePage_Text_YearCardSubCopy}
            IF  "visible" in "${subtext_state}"
                Run Keyword And Continue On Failure    Get Text    ${card} >> ${OurHeritagePage_Text_YearCardSubCopy} > :first-child     !=    ${EMPTY}
                Run Keyword And Continue On Failure    Get Classes    ${card} >> ${OurHeritagePage_Text_YearCardSubCopy} > :first-child     validate    any('italic' in v for v in value) or ('t-body-xs' in value)
            END
           
            ${link_state}    Run Keyword And Continue On Failure    Get Element States    ${card} >> ${OurHeritagePage_Link_YearCard}
            IF  "visible" in "${link_state}"
                Run Keyword And Continue On Failure    Get Text    ${card} >> ${OurHeritagePage_Link_YearCard}    !=    ${EMPTY}
                Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurHeritagePage_Link_YearCard} >> a    href    !=    ${EMPTY}
                Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurHeritagePage_Link_YearCard} >> a   data-a-comp    equals    Interactive Timeline
                Run Keyword And Continue On Failure    Get Attribute    ${card} >> ${OurHeritagePage_Link_YearCard} >> a   data-a-evt    equals    Link Click
            END
        END
    END
 

Check Timeline Disclosures
    Run Keyword And Continue On Failure    Get Text    ${OurHeritagePage_Text_Footnotes} >> p    equals    FOOTNOTES
    Run Keyword And Continue On Failure    Get Classes    ${OurHeritagePage_Text_Footnotes} >> p    contains    t-label-sm-heavy
    Run Keyword And Continue On Failure    Get Text    ${OurHeritagePage_Text_Footnotes} >> ol    !=    ${EMPTY}
 
    Run Keyword And Continue On Failure    Get Text    ${OurHeritagePage_Container_Disclosure} > p:first-child    equals    DISCLOSURES
    Run Keyword And Continue On Failure    Get Classes    ${OurHeritagePage_Container_Disclosure} > p:first-child    contains    t-label-sm-heavy
    Run Keyword And Continue On Failure    Get Text    ${OurHeritagePage_Text_Disclosure}


Check Timeline On Mobile
    Run Keyword And Continue On Failure    Get Element States    ${OurHeritagePage_Container_MobileYears}    contains    detached
    Run Keyword And Continue On Failure    Get Element States    ${OurHeritagePage_Container_MobileScrollBarDot}    contains    detached
    Run Keyword And Continue On Failure    Set Viewport Size    width=600    height=800
    Run Keyword And Continue On Failure    Get Element States    ${OurHeritagePage_Container_MobileYears}    contains    attached
    Run Keyword And Continue On Failure    Get Element States    ${OurHeritagePage_Container_MobileScrollBarDot}    contains    attached 
 
    ${mobile_timeline_buttons}    Get Elements    ${OurHeritagePage_Button_MobileYears}
    FOR    ${index}    ${year}    IN ENUMERATE    @{year_containers}
        Run Keyword And Continue On Failure    Get Attribute    ${year} >> ${OurHeritagePage_Image_YearFrame} >> img    src    !=    ${EMPTY}
        ${frame_year_text}    Run Keyword And Continue On Failure    Get Text    ${mobile_timeline_buttons}[${index}]
        Run Keyword And Continue On Failure    Get Attribute    ${year} >> ${OurHeritagePage_Image_YearFrame} >> img    alt    contains    ${frame_year_text}
    END