# This is page object for "us-en/dev-lab/qa-test-pages/about-us"


*** Variables ***
${AboutUsPage_Div_Leadership}                     \#leadership
${AboutUsPage_NavTab_BOD}                         [data-a-text="Board of Directors"]
${AboutUsPage_Div_BoardOfDirectors}               \#board-of-directors
${Leadership_Title}                               Global Leadership
${BoardOfDirectors_Title}                         d Directors
${AboutUsPage_Section_HeaderTitle}                .header-video-container >> .header-title
${AboutUsPage_Source_HeaderVideo}                 .header-video
${AboutUsPage_Thumbnail_HeaderVideo}              .header-video-thumbnail
${AboutUsPage_Text_FFTitle}                       .fast-facts-default-title > h2
${AboutUsPage_Text_FFSubTitle}                    .fast-facts-default-subTitle > p
${AboutUsPage_Card_FFDataPoint}                   .data-point-default
${AboutUsPage_Card_FFDataPointTitle}              .data-point-default-title > h2
${AboutUsPage_Card_FFDataPointDescription}        .data-point-default-desc > p:first-child
${AboutUsPage_Div_SpringBoardCards}               .springboard-card
${AboutUsPage_FirstSpringBoard_Eyebrow}           .springboard-container > div:first-child >> .eyebrow
${AboutUsPage_Div_SecondSpringBoard}              .springboard-container > div:nth-child(2)
${AboutUsPage_Container_OneColumnCenter}          .center-container:nth-child(2)
${AboutUsPage_Style_OCTAccentBar}                 ${AboutUsPage_Container_OneColumnCenter} >> .one-column-text-accent-bar
${AboutUsPage_Text_OCTEyebrow}                    ${AboutUsPage_Container_OneColumnCenter} >> .eyebrow
${AboutUsPage_Text_OCTTitle}                      ${AboutUsPage_Container_OneColumnCenter} >> .title > h2
${AboutUsPage_Text_OCTDescription}                ${AboutUsPage_Container_OneColumnCenter} >> p
${AboutUsPage_Image_FullWidthVideo}               .full-width-media >> .video-popup--card-image
${AboutUsPage_Button_FullWidthVideoPlay}          .full-width-media >> .image-play-video
${AboutUsPage_Video_FullWidthVideoPopup}          .video-modal-iframe
${AboutUsPage_Button_FullWidthVideoPopupClose}    .video-modal-close-button
${AboutUsPage_Container_FullWidthVideoCard}       .text-card-container > .text-card
${AboutUsPage_Text_FullWidthVideoCardTitle}       ${AboutUsPage_Container_FullWidthVideoCard} > .title
${AboutUsPage_Text_FullWidthVideoCardDesc}        ${AboutUsPage_Container_FullWidthVideoCard} > .description
${AboutUsPage_Text_FullWidthVideoCardLength}      ${AboutUsPage_Container_FullWidthVideoCard} > .video-duration

*** Keywords ***

Verify Title and Description
    Run Keyword And Continue On Failure        Wait For Elements State        ${AboutUsPage_Div_Leadership}    visible
    Run Keyword And Continue On Failure        Get Element Count        ${AboutUsPage_Div_Leadership} >> .people-container        ==        2
    Run Keyword And Continue On Failure        Get Text        ${AboutUsPage_Div_Leadership} > div:first-child >> .people-title > h1        ==     ${Leadership_Title}
    Get Text       ${AboutUsPage_Div_Leadership} > div:last-of-type >> .people-description > p   !=    ${EMPTY}

Verify In-page Tab
    Click   ${AboutUsPage_NavTab_BOD}
    Run Keyword And Continue On Failure        Get Classes        ${AboutUsPage_NavTab_BOD}        *=    active
    Run Keyword And Continue On Failure        Get Text        ${AboutUsPage_Div_BoardOfDirectors} > div:first-child >> .people-title > h1        ==     ${BoardOfDirectors_Title}
    # Verify no in-page tabs for German page
    Run Keyword And Continue On Failure        New Page        ${PUBLIC_SITE_CMS_URL}/${AboutUs_CMSPage_PathDE}
    Run Keyword And Continue On Failure        Get Element Count         ${AboutUsPage_NavTab_BOD}     ==     0
    Close Page

Verify People Card Details
    ${director_cards}    Get Elements         ${AboutUsPage_Div_BoardOfDirectors} > div:first-child >> .people-card
    FOR  ${card}  IN  @{director_cards}
        Run Keyword And Continue On Failure        Get Attribute       ${card} >> .people-card-image        src    !=    ${EMPTY}
        Run Keyword And Continue On Failure        Get Text        ${card} >> .people-card-text-name    !=     ${EMPTY}
        Run Keyword And Continue On Failure        Get Text        ${card} >> .people-card-text-position    !=     ${EMPTY}
        Run Keyword And Continue On Failure        Get Attribute       ${card} >> text=View Bio       data-a-comp        contains         People Card       #Verify GA attribute
    END

Verify Header Background Video
    Get Attribute    ${AboutUsPage_Source_HeaderVideo} > source    type    !=    ${EMPTY}
    Get Attribute    ${AboutUsPage_Source_HeaderVideo} > source    src     !=    ${EMPTY}

Verify Header Title, Subtitle and Accent Bar
    Run Keyword And Continue On Failure    Get Classes    ${AboutUsPage_Section_HeaderTitle} > div:first-child    validate    any("accent" in v for v in value)
    Get Property    ${AboutUsPage_Section_HeaderTitle} > h1    innerText    !=    ${EMPTY}

    # Subtitle is not authored on live site
    IF  '${environment}' != 'production'
        Get Property    ${AboutUsPage_Section_HeaderTitle} >> .t-subtitle    innerText    !=    ${EMPTY}
    END

Verify Mobile Background Image And Poster Image
    Get Attribute    ${AboutUsPage_Thumbnail_HeaderVideo}    src    !=    ${EMPTY}
    Get Attribute    ${AboutUsPage_Source_HeaderVideo}    poster    !=    ${EMPTY}

Check FastFacts Title and Subtitle
    Get Text    ${AboutUsPage_Text_FFTitle}    !=    ${EMPTY}
    Get Text    ${AboutUsPage_Text_FFSubTitle}    !=    ${EMPTY}

Check English Datapoints Count
    Get Element Count    ${AboutUsPage_Card_FFDataPoint}    >=    1

Check Datapoints Title and Description
    ${dp_slides}    Get Elements    ${AboutUsPage_Card_FFDataPoint}
    FOR    ${slide}  IN  @{dp_slides}
        Get Text    ${slide} >> ${AboutUsPage_Card_FFDataPointTitle}    !=    ${EMPTY}
        Get Text    ${slide} >> ${AboutUsPage_Card_FFDataPointDescription}    !=    ${EMPTY}
    END

Check German Datapoints Count
    IF  '${environment}' == 'production'
        Go To    url=${PUBLIC_SITE_URL}/de-de/who-we-are/about-us
    ELSE
        Go To    url=${PUBLIC_SITE_CMS_URL}/${AboutUs_CMSPage_PathDE}
    END
    Get Element Count    ${AboutUsPage_Card_FFDataPoint}    >=    1

Verify Springboard Eyebrow, Headline,GA and CTA
    Run Keyword And Continue On Failure     Get Element Count        ${AboutUsPage_Div_SpringBoardCards}    <=    3
    Run Keyword And Continue On Failure        Get Text        ${AboutUsPage_FirstSpringBoard_Eyebrow}     !=     ${EMPTY}
    Run Keyword And Continue On Failure        Get Text        ${AboutUsPage_Div_SecondSpringBoard} >> .headline     !=     ${EMPTY}
    Run Keyword And Continue On Failure        Get Attribute       ${AboutUsPage_Div_SecondSpringBoard} >> a       data-a-comp        contains         Springboard Card       #Verify GA attribute
    Click       ${AboutUsPage_Div_SecondSpringBoard} >> a
    Wait For Condition        Url        not contains        about-us

Verify One Column Center Container
    Run Keyword And Continue On Failure    Wait For Elements State    ${AboutUsPage_Container_OneColumnCenter}    visible
    Get Property    ${AboutUsPage_Container_OneColumnCenter}    className    contains    col-8

Verify One Column Text Accent Bar, Eyebrow, Title and Description
    Run Keyword If  '${environment}' != 'production'  Get Attribute    ${AboutUsPage_Style_OCTAccentBar}    style    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Text    ${AboutUsPage_Text_OCTEyebrow}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Text    ${AboutUsPage_Text_OCTTitle}    !=    ${EMPTY}
    Get Text    ${AboutUsPage_Text_OCTDescription}    !=    ${EMPTY}

Verify Full Width Video
    Run Keyword And Continue On Failure    Get Attribute    ${AboutUsPage_Image_FullWidthVideo}    src    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Click    ${AboutUsPage_Button_FullWidthVideoPlay}
    Run Keyword And Continue On Failure    Get Attribute    ${AboutUsPage_Video_FullWidthVideoPopup}    src    !=    ${EMPTY}
    Click    ${AboutUsPage_Button_FullWidthVideoPopupClose}

Verify Full Width Video Card Title, Description and Video-duration
    Run Keyword And Continue On Failure    Get Property    ${AboutUsPage_Container_FullWidthVideoCard}    className    contains    left
    Run Keyword And Continue On Failure    Get Text    ${AboutUsPage_Text_FullWidthVideoCardTitle}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Text    ${AboutUsPage_Text_FullWidthVideoCardDesc}    !=    ${EMPTY}
    Get Text    ${AboutUsPage_Text_FullWidthVideoCardLength}    !=    ${EMPTY}