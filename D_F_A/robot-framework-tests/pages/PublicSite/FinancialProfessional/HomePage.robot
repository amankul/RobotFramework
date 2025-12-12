# This is page object for "us-en/dev-lab/qa-test-pages/financial-professionals"


*** Variables ***
${HomePage_Text_CarouselContainerTitle}      div.carousel-card-section-title
${HomePage_Link_CarouselContainerCTA}        div.carousel-card-link
${HomePage_Div_FeaturedCard}                 div.carousel-card-featured
${HomePage_Div_ContentCard}                  (//div[@class="carousel-card"])[1]
${HomePage_Button_CarouselPrv}               button.carousel-card-arrow-btn-prev
${HomePage_Button_CarouselNext}              button.carousel-card-arrow-btn-next
${HomePage_Div_VisibleSlides}                [class*="_dCarouselCard"][class*="visible"]
${HomePage_Div_UtilityContainer}             .utility-container
${HomePage_Card_FirstSpringboardPlus}        .springboard-plus-card:first-of-type
${HomePage_Section_HeaderVideo}              .header-video
${HomePage_Section_HeaderTitle}              .header-video-container >> .header-title
${HomePage_Text_HeaderTitleStaticLine}       ${HomePage_Section_HeaderTitle} >> .first-line
${HomePage_Text_HeaderTitleAnimatedLines}    ${HomePage_Section_HeaderTitle} >> .animated-text
${HomePage_Thumbnail_HeaderVideo}            .header-video-thumbnail

*** Keywords ***
Verify Carousel Container Header and CTA
    Run Keyword And Continue On Failure        Get Text        ${HomePage_Text_CarouselContainerTitle}        !=        ${EMPTY}
    Click       ${HomePage_Link_CarouselContainerCTA}
    Wait For Condition        Url        not contains        financial-professionals

Verify Featured Content Card
    Run Keyword And Continue On Failure        Get Text        ${HomePage_Div_FeaturedCard} >> .carousel-card-category       !=        ${EMPTY}
    Run Keyword And Continue On Failure        Get Text        ${HomePage_Div_FeaturedCard} >> .carousel-card-description       !=        ${EMPTY}
    Run Keyword And Continue On Failure       Get Attribute    ${HomePage_Div_FeaturedCard} >> img        src    !=    ${EMPTY}
    Click       ${HomePage_Div_FeaturedCard}
    Wait For Condition        Url        not contains        financial-professionals
    Go Back

Verify Content Card
    Run Keyword And Continue On Failure       Run Keyword If  '${environment}' != 'production'      Get Text        ${HomePage_Div_ContentCard} >> .carousel-card-date       !=        ${EMPTY}
    Run Keyword And Continue On Failure       Get Text        ${HomePage_Div_ContentCard} >> .carousel-card-title       !=        ${EMPTY}
    Get Attribute       ${HomePage_Div_ContentCard}       data-a-comp        contains         Card Carousel       #Verify GA attribute

Verify Scroll
    Run Keyword And Continue On Failure       Get Element States     ${HomePage_Button_CarouselPrv}    contains    visible    disabled    readonly
    ${visible_slides}    Get Elements    ${HomePage_Div_VisibleSlides}
    ${old_slide}        Get Text          ${visible_slides}[0]
    Click         ${HomePage_Button_CarouselNext}
    Run Keyword And Continue On Failure       Get Text       ${visible_slides}[0]        !=        ${old_slide}
    Run Keyword And Continue On Failure       Get Attribute       ${HomePage_Div_FeaturedCard} >> ..       aria-hidden        ==     true
    # Renable this code after DDXP-8456 is fixed
    # Click         ${HomePage_Button_CorouselNext}
    # Run Keyword If  '${environment}' != 'production'    Wait For Elements State     ${HomePage_Button_CorouselNext}        disabled

Verify Hover Effect
    Hover        ${HomePage_Div_FeaturedCard}
    Get Style      ${HomePage_Div_FeaturedCard}        background-color     ==     ${AlmostBlack}

Verify Title and Description Utility Container
    Run Keyword And Continue On Failure        Get Text        ${HomePage_Div_UtilityContainer} >> .title       !=        ${EMPTY}
    Run Keyword And Continue On Failure        Get Text        ${HomePage_Div_UtilityContainer} >> .description       !=        ${EMPTY}
    IF    '${environment}' != 'production'
        Run Keyword And Continue On Failure        Get Classes     ${HomePage_Div_UtilityContainer} > div:first-child    validate    any("accent" in v for v in value)
        Click            ${HomePage_Div_UtilityContainer} >> .cta-meatball-link
        Run Keyword And Continue On Failure       Wait For Condition        Url        contains        pause
        Go Back
    END

Test Springboard Plus Card
    Run Keyword And Continue On Failure        Get Text        ${HomePage_Card_FirstSpringboardPlus} > div.card-title       !=        ${EMPTY}
    Run Keyword And Continue On Failure        Get Text        ${HomePage_Card_FirstSpringboardPlus} > div.card-description       !=        ${EMPTY}
    Hover       ${HomePage_Card_FirstSpringboardPlus}
    Run Keyword And Continue On Failure        Get Style      ${HomePage_Card_FirstSpringboardPlus}        background-color     ==     ${Cement02}
    Run Keyword And Continue On Failure        Get Style      ${HomePage_Card_FirstSpringboardPlus} > div.card-link         color     ==     ${Teal04}
    Click            ${HomePage_Card_FirstSpringboardPlus}
    Wait For Condition        Url        not contains        financial-professionals

Verify ProHome Header Background Video
    Get Attribute    ${HomePage_Section_HeaderVideo} > source    type    !=    ${EMPTY}
    Get Attribute    ${HomePage_Section_HeaderVideo} > source    src    !=    ${EMPTY}

Verify ProHome Header Title Static Line, Animated Lines and Accent Bar
    Get Property    ${HomePage_Text_HeaderTitleStaticLine}    innerText    !=    ${EMPTY}
    ${AnimatedLines}    Get Elements    ${HomePage_Text_HeaderTitleAnimatedLines}
    FOR  ${AnimatedLine}  IN  @{AnimatedLines}
        Get Property    ${AnimatedLine}    innerText    !=    ${EMPTY}
    END

    # Accent bar is not visible on live site as text is center aligned
    IF  '${environment}' != 'production'
        Run Keyword And Continue On Failure    Get Classes    ${HomePage_Section_HeaderTitle} > div:first-child    validate    any("accent" in v for v in value)
    END

Verify ProHome Header Mobile Background Image And Poster Image
    Get Attribute    ${HomePage_Thumbnail_HeaderVideo}    src    !=    ${EMPTY}
    Get Attribute    ${HomePage_Section_HeaderVideo}    poster    !=    ${EMPTY}


Check Professional Audience Navigation Links
    [Arguments]    ${linktype}
    Run Keyword And Continue On Failure    Run Keyword If    "${linktype}" == "headers"    Verify Header Links
    Run Keyword And Continue On Failure    Run Keyword If    "${linktype}" == "footers"    Verify Footer Links