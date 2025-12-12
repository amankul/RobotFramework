# This is page object for "us-en/dev-lab/qa-test-pages/d-360"

*** Variables ***
${d360_Container_FullWidthImage}           .full-width-image-container > img
${d360_Container_FullWidthImageCard}       .text-card
${d360_Div_InformationCards}               .information-card
${d360_Link_CTAMeatball}                   .cta-area >> .cta-meatball-link
${d360_Container_Utility}                  .bg-img .utility-container
${d360_Section_UtilityCards}               .utility-card
${d360_Section_FeaturedTextBox}            .featured-text-box
${d360_Text_FeaturedTextBoxEyebrow}        .featured-text-box-eyebrow
${d360_Text_FeaturedTextBoxHeadline}       .featured-text-box-headline
${d360_Text_FeaturedTextBoxDescription}    .featured-text-box-description
${d360_iFrame_PopupVideo}                  .video-modal-iframe
${d360_Button_PlayVideo}                   .image-play-video
${d360_Class_HorizontalDividers}           [class*="divider"]
${d360_Class_Spacers}                      [class*="spacer2"]
${d360_Container_Image}                    .content-page-module-image
${d360_Button_ImageComponentTooltip}       [data-qa="button-icon-info-popup"]
${d360_Container_ImageComponentTooltip}    [data-id="tooltip"]


*** Keywords ***
Verify Full Width Image And Card
    Run Keyword And Continue On Failure    Get Attribute    ${d360_Container_FullWidthImage}    alt    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${d360_Container_FullWidthImage}    src    !=    ${EMPTY}

    IF  '${environment}' != 'production'
        Run Keyword And Continue On Failure    Get Classes    ${d360_Container_FullWidthImageCard}    contains    right
        Run Keyword And Continue On Failure    Get Style    ${d360_Container_FullWidthImageCard}    background-color    ==    ${WarmGray06}

        Run Keyword And Continue On Failure    Get Text    ${d360_Container_FullWidthImageCard} > .title    contains    Automation
        Run Keyword And Continue On Failure    Get Style    ${d360_Container_FullWidthImageCard} > .title    color    ==    ${AlmostBlack}
        Run Keyword And Continue On Failure    Get Classes    ${d360_Container_FullWidthImageCard} > .title    validate    any("heading-md" in v for v in value)

        Run Keyword And Continue On Failure    Get Text    ${d360_Container_FullWidthImageCard} > .description    contains    verification
        Run Keyword And Continue On Failure    Get Style    ${d360_Container_FullWidthImageCard} > .description    color    ==    ${AlmostBlack}
        Get Classes    ${d360_Container_FullWidthImageCard} > .description    validate    any("body-xs" in v for v in value)
    END


Verify All Information Cards
    ${info_cards}    Get Elements    ${d360_Div_InformationCards}
    FOR    ${info_card}    IN    @{info_cards}
        Run Keyword And Continue On Failure    Get Text    ${info_card} >> .card-title    !=    ${EMPTY}
        # Uncomment after changing title color to blue DDXP-8290 is fixed
        # IF    '${environment}' != 'production'
        #     Run Keyword And Continue On Failure        Get Classes     ${info_card} >> .card-title     validate    any("blue" in v for v in value)
        # END
        Run Keyword And Continue On Failure    Get Text    ${info_card} >> .card-description    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Style   ${info_card} >> .card-description    color    ==    ${CoolGray01}
    END


Verify CTA Area
    Run Keyword And Continue On Failure   Get Attribute       ${d360_Link_CTAMeatball}        data-a-comp        contains         Utility Container
    Run Keyword And Continue On Failure    Get Text    ${d360_Link_CTAMeatball} >> .link-text    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style   ${d360_Link_CTAMeatball} >> .circle    fill    ==    ${Poppy01}
    Run Keyword And Continue On Failure   Hover    ${d360_Link_CTAMeatball}
    Get Style   ${d360_Link_CTAMeatball} >> .circle    fill    ==    ${CoolGray01}


Verify Utility Container Accent Bar and Theme
    [Documentation]    We are validating specifically the stacked theme and accent bar that were not validated in springboard plus cards.
    ...                Additionally, validating the font style for container title.

    IF  '${environment}' != 'production'
        Run Keyword And Continue On Failure    Get Classes    ${d360_Container_Utility} > div:first-child    validate    any("poppy" in v for v in value)
    END
    Run Keyword And Continue On Failure    Get Classes    ${d360_Container_Utility} > .header    contains    stacked
    Run Keyword And Continue On Failure    Get Classes    ${d360_Container_Utility} >> .title > div    contains    t-heading-xl
    Get Style    ${d360_Container_Utility} >> .title > div    color    ==    ${AlmostBlack}


Verify Utility Cards Title, Description and Meatball
    ${util_cards}    Get Elements    ${d360_Section_UtilityCards}
    FOR    ${util_card}    IN    @{util_cards}
        Run Keyword And Continue On Failure    Get Text    ${util_card} >> .card-title    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Classes    ${util_card} >> .card-title    contains    t-body-xl-heavy
        Run Keyword And Continue On Failure    Get Style    ${util_card} >> .card-title    color    ==    ${Teal01}

        Run Keyword And Continue On Failure    Get Text    ${util_card} >> .card-description    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Classes    ${util_card} >> .card-description    contains    t-body-md
        Run Keyword And Continue On Failure    Get Style    ${util_card} >> .card-description    color    ==    ${AlmostBlack}

        Run Keyword And Continue On Failure    Get Attribute    ${util_card} >> a    data-a-comp    equals    Utility Card
        Run Keyword And Continue On Failure    Get Style   ${util_card} >> .circle    fill    ==    ${Poppy01}
        Run Keyword And Continue On Failure   Hover    ${util_card} >> .circle
        Run Keyword And Continue On Failure    Get Style   ${util_card} >> .circle    fill    ==    ${CoolGray01}
        Run Keyword And Continue On Failure    Get Text    ${util_card} >> .link-text    !=    ${EMPTY}
        ${link}    Run Keyword And Continue On Failure    Get Attribute    ${util_card} >> a    href
        Run Keyword And Continue On Failure    Click    ${util_card} >> .link-text
        Run Keyword And Continue On Failure    Wait For Condition    Url   equals    ${link}
        Run Keyword And Continue On Failure    Go Back
    END


Verify Featured Text Box Accent Bar, Eyebrow and Headline
        Run Keyword And Continue On Failure    Get Classes    ${d360_Section_FeaturedTextBox} > div:first-child    validate    any("green" in v for v in value)

        Run Keyword And Continue On Failure    Get Style    ${d360_Text_FeaturedTextBoxEyebrow}    color    ==    ${CoolGray02}
        Run Keyword And Continue On Failure    Get Text    ${d360_Text_FeaturedTextBoxEyebrow}    *=    EYEBROW
        Run Keyword And Continue On Failure    Get Classes    ${d360_Text_FeaturedTextBoxEyebrow}    contains    t-label-sm-heavy

        Run Keyword And Continue On Failure    Get Style    ${d360_Text_FeaturedTextBoxHeadline}    color    ==    ${AlmostBlack}
        Run Keyword And Continue On Failure    Get Classes    ${d360_Text_FeaturedTextBoxHeadline}    contains    t-heading-xl
        Run Keyword And Continue On Failure    Get Text    ${d360_Text_FeaturedTextBoxHeadline}    equals    ${QA_Test_Characterset}


 Verify Featured Text Box Description
    Run Keyword And Continue On Failure    Get Style    ${d360_Text_FeaturedTextBoxDescription}    color    ==    ${AlmostBlack}
    Run Keyword And Continue On Failure    Get Text    ${d360_Text_FeaturedTextBoxDescription}    !=    ${EMPTY}
    Get Classes    ${d360_Text_FeaturedTextBoxDescription}    contains    t-body-md


Verify Video Plays
    [Arguments]    ${video_type}
    IF  '${video_type}' == 'popup'
        Click    ${d360_Button_PlayVideo}
        Set Selector Prefix    ${d360_iFrame_PopupVideo} >>>    Test
    END
    ${startTime}     Run Keyword And Continue On Failure    Get Text    .vjs-current-time-display
    Click    .vjs-big-play-button
    Run Keyword And Continue On Failure    Wait For Elements State    .vjs-play-control    visible
    Run Keyword And Continue On Failure    Get Classes    .vjs-play-control    contains    vjs-playing
    Sleep    5s
    Click    .vjs-play-control
    Run Keyword And Continue On Failure    Wait For Condition    Classes    .vjs-play-control    contains    vjs-paused    timeout=20
    ${currentTime}     Run Keyword And Continue On Failure    Get Text    .vjs-current-time-display
    Should Be True    "${currentTime}" != "${startTime}"


Verify Video Controls
    Run Keyword And Continue On Failure    Verify Control Present    button.vjs-subs-caps-button
    Run Keyword And Continue On Failure    Verify Control Present    .vjs-mute-control
    Run Keyword And Continue On Failure    Verify Control Present    .vjs-volume-panel
    Run Keyword And Continue On Failure    Verify Control Present    button.vjs-playback-rate
    Verify Control Present    .vjs-share-control


Verify Control Present
    [Arguments]    ${control_name}
    Get Element States    ${control_name}   contains    visible


Verify Popup Video iFrame
    Set Selector Prefix    ${None}
    Run Keyword And Continue On Failure    Get Element States    ${d360_iFrame_PopupVideo}    contains    attached
    Run Keyword And Continue On Failure    Click    .video-modal-close-button
    Get Element States    ${d360_iFrame_PopupVideo}    ==    detached


Check Divider Height, Color and Class
    ${dividers}    Get Elements    ${d360_Class_HorizontalDividers}
    Run Keyword And Continue On Failure    Get Style    ${dividers}[0]    height     ==    1px
    Run Keyword And Continue On Failure    Get Classes    ${dividers}[0]    equals    horizontal-divider
    Get Style    ${dividers}[0]    background-color    ==    ${WarmGray04}


Check Spacer Height and Class
    ${spacers}    Get Elements    ${d360_Class_Spacers}
    Run Keyword And Continue On Failure    Get Style    ${spacers}[0]    height    ==    80px
    Get Classes    ${spacers}[0]    equals    spacer2_10x


Verify Image Component Title, Description and Borders
    Run Keyword And Continue On Failure    Get Text    ${d360_Container_Image} >> .title    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Text    ${d360_Container_Image} >> .description    equals    ${QA_Test_Characterset}
    Run Keyword And Continue On Failure    Get Classes    ${d360_Container_Image}    validate    any("--border-top" in v for v in value)
    Run Keyword And Continue On Failure    Get Classes    ${d360_Container_Image} >> [class*="border"]    validate    any("-bottom" in v for v in value)
    Run Keyword And Continue On Failure    Get Style    ${d360_Container_Image}    border-top    contains    ${WarmGray04}
    Run Keyword And Continue On Failure    Get Style    ${d360_Container_Image} >> [class*="border"]    border-bottom    contains    ${WarmGray04}


Verify Image Component Image
    Run Keyword And Continue On Failure    Get Attribute    ${d360_Container_Image} >> source    srcset    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${d360_Container_Image} >> img    src    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${d360_Container_Image} >> a    href    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Click    ${d360_Container_Image}
    Run Keyword And Continue On Failure    Wait For Condition    Url    !=    ${PUBLIC_SITE_CMS_URL}/${d360_CMSPage_Path}
    Run Keyword And Continue On Failure    Go Back


Verify Image Component Tooltip
    Run Keyword And Continue On Failure    Hover    ${d360_Button_ImageComponentTooltip}
    Run Keyword And Continue On Failure    Get Classes    ${d360_Container_ImageComponentTooltip}    contains    show
    Run Keyword And Continue On Failure    Get Style    ${d360_Container_ImageComponentTooltip}    visibility    equals    visible
    Get Text    ${d360_Container_ImageComponentTooltip}    !=    ${EMPTY}