*** Variables ***

${HowToInvestPage_Text_FlexHeaderTitle}          .flex-header-text-title
${HowToInvestPage_Text_FlexHeaderEyebrow}        .flex-header-text-eyebrow
${HowToInvestPage_Text_FlexHeaderSubtitle}       .flex-header-text-subtitle
${HowToInvestPage_Style_FlexHeaderAccentBar}     .flex-header-text-accent-bar
${HowToInvestPage_Text_FlexHeaderDescription}    .flex-header-text-description
${HowToInvestPage_Image_FlexHeader}              .flex-header-image
${HowToInvestPage_Section_StickyHeader}          [data-qa="sticky-header"]
${HowToInvestPage_Link_AnchorLink}               .anchor-link

*** Keywords ***

Check Flex Header Eyebrow, Title and Subtitle
    Run Keyword And Continue On Failure    Get Text    ${HowToInvestPage_Text_FlexHeaderTitle}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style    ${HowToInvestPage_Text_FlexHeaderTitle} >> h1    color    ==    ${AlmostBlack}
    IF  '${environment}' != 'production'
        Run Keyword And Continue On Failure    Get Text    ${HowToInvestPage_Text_FlexHeaderEyebrow}    contains    TEST
        Run Keyword And Continue On Failure    Get Text    ${HowToInvestPage_Text_FlexHeaderSubtitle}    equals    ${QA_Test_Characterset}
    END

Check Flex Header Accent Bar and Description
    Run Keyword And Continue On Failure    Get Classes    ${HowToInvestPage_Style_FlexHeaderAccentBar}    contains    accent-bar-poppy
    Run Keyword And Continue On Failure    Get Text    ${HowToInvestPage_Text_FlexHeaderDescription}    !=    ${EMPTY}
    Get Style    ${HowToInvestPage_Text_FlexHeaderDescription}    color    ==    ${AlmostBlack}


Check Flex Header Image
    Run Keyword And Continue On Failure    Get Attribute    ${HowToInvestPage_Image_FlexHeader} >> img    alt    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${HowToInvestPage_Image_FlexHeader} >> img    src    contains    .svg
    Get Attribute    ${HowToInvestPage_Image_FlexHeader} >> source    srcset    contains    .svg


Check Anchor Link Icon, Text and GA Attributes
    ${anchor_links}    Get Elements    ${HowToInvestPage_Link_AnchorLink}
    Set Test Variable    ${anchor_links}
    FOR    ${anchor_link}  IN  @{anchor_links}
        Run Keyword And Continue On Failure    Get Attribute    ${anchor_link} >> path    d    matches    ^M.*L.*Z$
        Run Keyword And Continue On Failure    Get Style   ${anchor_link} >> path    fill    ==    ${Poppy01}
        Run Keyword And Continue On Failure    Hover    ${anchor_link} >> path
        Run Keyword And Continue On Failure    Wait For Condition    Style   ${anchor_link} >> path    fill    ==    ${CoolGray01}
        Run Keyword And Continue On Failure    Get Text    ${anchor_link} >> span    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Classes    ${anchor_link} >> span    *=    t-heading-md
        Run Keyword And Continue On Failure    Get Style   ${anchor_link} >> span    color    ==    ${CoolGray01}
        Run Keyword And Continue On Failure    Get Attribute    ${anchor_link}    data-a-evt    equals    Subcontent View
        Run Keyword And Continue On Failure    Get Attribute    ${anchor_link}    data-a-comp    equals    Anchor Link
    END


Check Anchor Link Scroll
    FOR    ${anchor_link}  IN  @{anchor_links}
        ${target_element}    Get Attribute    ${anchor_link}    href
        Log    ...    console=True
        Log    --------------------------------------------------------------------------------------    console=True
        Log    Checking scroll behaviour for ${target_element.strip('#')} anchor link    console=True
        Log    --------------------------------------------------------------------------------------    console=True

        # Get the anchored scroll position by clicking the anchor links
        ${anchored_scroll_position}    Run Keyword And Continue On Failure    Check Scroll Using Anchor Link    ${anchor_link}

        # Scroll using browser scroll functionality by scrolling to the anchored scroll position and then further scrolling by offset amount.
        ${automated_scroll_position}    Run Keyword And Continue On Failure    Check Scroll Using Browser    ${target_element}

        # Compare the two scroll positions and make sure the difference is not more than 5 pixels.
        Run Keyword And Continue On Failure    Should Be True    abs(${anchored_scroll_position} - ${automated_scroll_position}) < 5
    END


Check Scroll Using Anchor Link
    [Arguments]    ${anchor_link}
    Run Keyword And Continue On Failure    Click    ${anchor_link}
    Run Keyword And Continue On Failure    Wait For Page To Stop Scrolling
    ${anchored_scroll_position}    Run Keyword And Continue On Failure    Get Scroll Position    key=top
    Log    The anchored scroll position is: ${anchored_scroll_position}    console=True
    RETURN    ${anchored_scroll_position}


Check Scroll Using Browser
    [Arguments]    ${target_element}
    Run Keyword And Continue On Failure    Scroll To Element    ${target_element}    # Scroll to the hidden anchor target element. This scroll brings the element to the center of the page.
    ${element_location}    Run Keyword And Continue On Failure    Get BoundingBox    ${target_element}    y
    ${header_height}    Run Keyword And Continue On Failure    Get BoundingBox    ${HowToInvestPage_Section_StickyHeader}    height
    ${offset}    Run Keyword And Continue On Failure    Evaluate    (${element_location} - ${header_height})    # Subtract the sticky header height from the target element y location to get the extra offset needed to scroll more and bring the element to the top of the page.
    Run Keyword And Continue On Failure    Scroll By    vertical=${offset}    # Perform a second scroll by that offset amount.
    ${automated_scroll_position}    Run Keyword And Continue On Failure    Get Scroll Position    key=top
    Log    The automated scroll position is: ${automated_scroll_position}    console=True
    RETURN    ${automated_scroll_position}