*** Variables ***

${IndHomePage_Container_ImageCard}               .image-card-container
${IndHomePage_Container_ImageCardActive}         ${IndHomePage_Container_ImageCard} >> [class*="visible"]
${IndHomePage_Text_ImageCardTitle}               .carousel-card-image-wrapper-title
${IndHomePage_Text_ImageCardDescription}         .carousel-card-image-wrapper-link-text-description
${IndHomePage_Button_ImageCarouselPrevious}      .carousel-card-arrow-btn-prev
${IndHomePage_Button_ImageCarouselNext}          .carousel-card-arrow-btn-next
${IndHomePage_Image_ImageCarouselImage}          .carousel-card-image
${IndHomePage_Style_ImageCardGradient}           rgba(125, 125, 122, 0.35)
${IndHomePage_TextArea_ImageCarousel}            .card-text-box
${IndHomePage_Style_ImageCarouselAccentBar}      ${IndHomePage_TextArea_ImageCarousel} >> [class*="accent-bar"]
${IndHomePage_Text_ImageCarouselDescription}     ${IndHomePage_TextArea_ImageCarousel} >> [class*="description"]
${IndHomePage_Text_ImageCarouselEyebrow}         ${IndHomePage_TextArea_ImageCarousel} >> [class*="eyebrow"]
${IndHomePage_Text_ImageCarouselHeadline}        ${IndHomePage_TextArea_ImageCarousel} >> [class*="headline"]
${IndHomePage_Link_ImageCarouselMeatball}        ${IndHomePage_TextArea_ImageCarousel} >> .cta-meatball-link
${IndHomePage_Container_AnimatedMarkets}         .animated-markets
${IndHomePage_Container_AnimatedFastFacts}         .animated-fast-facts-section
${IndHomePage_Button_AudienceSwitchCTA}              [data-qa="nav-header-link-audience-switcher-cta"],[data-qa="d-primary-nav-button"]

*** Keywords ***

Verify Image Card Title, Description and Image
    Scroll To Element    ${IndHomePage_Container_ImageCard}
    ${all_image_cards}    Get Elements    ${IndHomePage_Image_ImageCarouselImage}
    Set Test Variable    ${image_cards}    ${all_image_cards}
    FOR  ${image_card}    IN    @{image_cards}
        Run Keyword And Continue On Failure    Get Text    ${image_card} >> ${IndHomePage_Text_ImageCardTitle}    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Text    ${image_card} >> ${IndHomePage_Text_ImageCardDescription}    !=    ${EMPTY}
        ${image_format}    Run Keyword And Continue On Failure    Get Attribute    ${image_card}   style
        Run Keyword And Continue On Failure    Should Be True    ('.png' in '${image_format}') or ('.jpg' in '${image_format}')
    END


Verify Image Card Carousel Scroll and Navigation
    Run Keyword And Continue On Failure    Get Element States    ${IndHomePage_Container_ImageCard} >> ${IndHomePage_Button_ImageCarouselPrevious}    validate    disabled
    Run Keyword And Continue On Failure    Get Element States    ${IndHomePage_Container_ImageCard} >> ${IndHomePage_Button_ImageCarouselNext}    validate    enabled
    ${previous_card_image}    Run Keyword And Continue On Failure    Get Style    ${IndHomePage_Container_ImageCardActive} >> ${IndHomePage_Image_ImageCarouselImage}    background-image
    ${previous_url}    Run Keyword And Continue On Failure    Get Url
    Run Keyword And Continue On Failure    Click    ${IndHomePage_Container_ImageCardActive}
    Run Keyword And Continue On Failure    Wait For Condition    Url    !=    ${previous_url}
    Run Keyword And Continue On Failure    Go Back
    Run Keyword And Continue On Failure    Click    ${IndHomePage_Container_ImageCard} >> ${IndHomePage_Button_ImageCarouselNext}
    Run Keyword And Continue On Failure    Get Element States    ${IndHomePage_Container_ImageCard} >> ${IndHomePage_Button_ImageCarouselPrevious}    validate    enabled
    Run Keyword And Continue On Failure    Get Style    ${IndHomePage_Container_ImageCardActive} >> ${IndHomePage_Image_ImageCarouselImage}    background-image    !=    ${previous_card_image}
    Run Keyword And Continue On Failure    Click    ${IndHomePage_Container_ImageCard} >> ${IndHomePage_Button_ImageCarouselNext}
    Run Keyword And Continue On Failure    Get Element States    ${IndHomePage_Container_ImageCard} >> ${IndHomePage_Button_ImageCarouselNext}    validate    disabled


Verify Image Card Hover
    Run Keyword And Continue On Failure    Get Style    ${IndHomePage_Container_ImageCardActive} >> ${IndHomePage_Image_ImageCarouselImage}    background-image    not contains    ${IndHomePage_Style_ImageCardGradient}
    Run Keyword And Continue On Failure    Hover    ${IndHomePage_Container_ImageCardActive}
    Run Keyword And Continue On Failure    Get Style    ${IndHomePage_Container_ImageCardActive} >> ${IndHomePage_Image_ImageCarouselImage}    background-image    contains    ${IndHomePage_Style_ImageCardGradient}


Verify Image Card GA Attributes
    Run Keyword And Continue On Failure    Get Attribute    ${IndHomePage_Container_ImageCardActive} >> ${IndHomePage_Image_ImageCarouselImage}    data-a-evt    equals    Link Click
    Get Attribute    ${IndHomePage_Container_ImageCardActive} >> ${IndHomePage_Image_ImageCarouselImage}    data-a-comp    equals    Card Carousel


Verify Image Card Carousel Container
    IF  '${environment}' != 'production'
        Run Keyword And Continue On Failure    Get Style    ${IndHomePage_Style_ImageCarouselAccentBar}    background-color    ==    ${Blue01}
        Run Keyword And Continue On Failure    Get Text    ${IndHomePage_Text_ImageCarouselDescription}    ==    ${QA_Test_Characterset}
        Run Keyword And Continue On Failure    Get Style    ${IndHomePage_Text_ImageCarouselDescription}    color    ==    ${AlmostBlack}
    END

    Run Keyword And Continue On Failure    Get Text    ${IndHomePage_Text_ImageCarouselEyebrow}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style    ${IndHomePage_Text_ImageCarouselEyebrow}    color    ==    ${CoolGray02}
    Run Keyword And Continue On Failure    Get Text    ${IndHomePage_Text_ImageCarouselHeadline}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style    ${IndHomePage_Text_ImageCarouselHeadline}    color    ==    ${AlmostBlack}
    Run Keyword And Continue On Failure    Get Attribute    ${IndHomePage_Link_ImageCarouselMeatball}    href    !=    ${EMPTY}
    ${current_url}    Run Keyword And Continue On Failure    Get Url
    Run Keyword And Continue On Failure    Click    ${IndHomePage_Link_ImageCarouselMeatball}
    Wait For Condition    Url    !=    ${current_url}

Check Cards Header
    Run Keyword And Continue On Failure    Get Classes    ${IndHomePage_Container_AnimatedMarkets} >> ../..    validate    any("third" in v for v in value) and ('top' or 'center' in value)
    Run Keyword And Continue On Failure    Scroll To Element       ${IndHomePage_Container_AnimatedMarkets}
    Run Keyword And Continue On Failure    Wait For Condition    Classes    ${IndHomePage_Container_AnimatedMarkets}    contains    animate
    ${headers}        Get Elements    ${IndHomePage_Container_AnimatedMarkets} >> .card-header
    FOR    ${header}    IN    @{headers}
        Run Keyword And Continue On Failure    Get Text    ${header} >> .title    !=     ${EMPTY}
        Run Keyword And Continue On Failure    Get Style    ${header} >> .title    color    ==    ${AlmostBlack}
        Run Keyword And Continue On Failure    Get Text    ${header} >> .subcopy    !=     ${EMPTY}
        Run Keyword And Continue On Failure    Get Classes    ${header} >> .subcopy    *=    t-heading-sm-italic
    END

Check Cards Footer
    ${images}        Get Elements    ${IndHomePage_Container_AnimatedMarkets} >> img
    FOR    ${image}    IN    @{images}
        Run Keyword And Continue On Failure    Get Attribute    ${image}    src    $=     svg
    END
    ${descriptions}        Get Elements    ${IndHomePage_Container_AnimatedMarkets} >> .description
    FOR    ${description}    IN    @{descriptions}
            Run Keyword And Continue On Failure    Get Text    ${description}    !=     ${EMPTY}
            Run Keyword And Continue On Failure    Get Style    ${description}    color    ==    ${CoolGray01}
    END

Check Animated Fast Facts Datapoints
    Run Keyword And Continue On Failure    Scroll To Element    ${IndHomePage_Container_AnimatedFastFacts}
    ${dp_slides}    Get Elements    ${IndHomePage_Container_AnimatedFastFacts} > div
    FOR    ${slide}  IN  @{dp_slides}
        Run Keyword And Continue On Failure    Wait For Condition    Style    ${slide}>>.animated-fast-facts-fact-text    animation-name    equals    animated-text-left-to-right
        Run Keyword And Continue On Failure    Get Text    ${slide} >> .t-fast-facts-number   !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Style    ${slide} >> .t-fast-facts-number   color     ==     ${CoolGray01}
        Run Keyword And Continue On Failure    Get Text    ${slide} >> .animated-fast-facts-desc >> p   !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Classes    ${slide} >> .animated-fast-facts-desc >> p   *=    tc-cool-gray-02
        Run Keyword And Continue On Failure    Get Style       ${slide}    background-color    equals    ${Yellow01}       pseudo_element=::after
        Run Keyword And Continue On Failure    Get Style       ${slide}    animation-name    equals     animated-border-top-to-bottom      pseudo_element=::after
    END


Check Individual Audience Navigation Links
    [Arguments]    ${linktype}
    Run Keyword And Continue On Failure    Run Keyword If    "${linktype}" == "headers"    Verify Header Links
    Run Keyword And Continue On Failure    Run Keyword If    "${linktype}" == "footers"    Verify Footer Links