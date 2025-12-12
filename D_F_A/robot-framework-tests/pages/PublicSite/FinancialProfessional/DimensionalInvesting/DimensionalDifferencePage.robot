# This is page object for "us-en/dev-lab/qa-test-pages/d-difference"

*** Variables ***
${dDifferencePage_Source_HeaderBannerVideo}                    .ddiff-header-video
${dDifferencePage_Text_HeaderBannerEyebrow}                    .ddiff-header-eyebrow
${dDifferencePage_Text_HeaderBannerTextLines}                  [class*="ddiff-header-text-animation"]
${dDifferencePage_Thumbnail_HeaderBannerVideo}                 .ddiff-header-thumbnail
${dDifferencePage_Container_FastFacts}                         .fast-facts-ddiff
${dDifferencePage_Cards_FFDatapoints}                          ${dDifferencePage_Container_FastFacts} >> .data-point-ddiff
${dDifferencePage_Text_FFDatapointSubdescription}              .data-point-sub-description
${dDifferencePage_Text_AnimatedParagraph}                      .ddiff-animated-paragraph
${dDifferencePage_Div_AnimatedDonut}                           .animated-donut
${dDifferencePage_Text_AnimatedDonutDisc}                      .animated-donuts-disclosure>span
${dDifferencePage_Tooltip_AnimatedDonut}                       .animated-donuts-little-i
${dDifferencePage_TooltipWindow_AnimatedDonut}                 [data-qa="d-tooltip-window"]
${dDifferencePage_Container_2ndStickyScroll}                   .content-page > div:nth-child(3)
${dDifferencePage_Section_AnimatedParagraph}                   ${dDifferencePage_Container_2ndStickyScroll} >> .ddiff-animated-section-border
${dDifferencePage_Container_ResearchInOurDNA}                  .ddiff-research-in-dna-container
${dDifferencePage_Image_StandaloneTooltip}                     .rails > [data-view="ui-platform-dtooltip"] >> [data-qa="d-icon-information-expressive"]
${dDifferencePage_Text_StandaloneTooltipDisclosure}            .rails > [data-view="ui-platform-dtooltip"] >> [data-qa="d-tooltip-window"]
${dDifferencePage_Text_LaureatesTitle}                         .ddiff-laureates-animated-exhibit > .title
${dDifferencePage_Container_Placards}                          .laureate-image-placard
${dDifferencePage_Button_LaureatesMeatball}                    .ddiff-laureates-animated-exhibit >> .cta-meatball-icon
${dDifferencePage_Button_LaureatesDescription}                 .expand-description-button
${dDifferencePage_Container_LaureatesDescription}              .laureate-description-container
${dDifferencePage_Text_LaureatesDescription}                   .laureate-description-text
${dDifferencePage_Container_OutperformedExhibit}               [data-view="ddiff-outperformed"]
${dDifferencePage_Text_OutperformedChartsTitle}                .ddiff-outperformed-charts-title
${dDifferencePage_Div_OutperformedCharts}                      .ddiff-outperformed-chart
${dDifferencePage_Text_PremiumsHeadline}                       .ddiff-animated-exhibit-premiums-headline >> .ddiff-animated-exhibit-headline
${dDifferencePage_Text_PremiumsTitle}                          .ddiff-premiums-info-title
${dDifferencePage_Style_PremiumsHeadline}                      .ddiff-animated-exhibit-premiums-headline >> .ddiff-animated-exhibit-border
${dDifferencePage_Label_PremiumsToggleLabelEquity}             .ddiff-switch-title-equity
${dDifferencePage_Label_PremiumsToggleLabelFixed}              .ddiff-switch-title-fixed
${dDifferencePage_Style_PremiumsToggleAnimation}               .ddiff-slider-pulse
${dDifferencePage_Checkbox_PremiumsToggle}                     .ddiff-premiums-switch
${dDifferencePage_Section_PremiumsCharts}                      .ddiff-premiums-charts >> [class*="ddiff-premium-chart-"]
${dDifferencePage_Symbol_QuoteBlock}                           .quote-block > svg > path
${dDifferencePage_Text_Quote}                                  .quote-block-text > p
${dDifferencePage_Text_QuoteName}                              .quote-block-name
${dDifferencePage_Text_QuoteTitle}                             .quote-block-title
${dDifferencePage_Div_BestOfBothContainer}                     .bb-title-container
${dDifferencePage_Text_BestOfBothSectionTitle}                 .bb-mobile-section-title
${dDifferencePage_Text_BestOfBothSectionSub}                   .bb-mobile-section-title-sub
${dDifferencePage_List_BestOfBothSectionAchievements}          .bb-mobile-items
${dDifferencePage_Container_MicroCapExhibit}                   .ddiff-micro-cap-wrapper
${dDifferencePage_Text_MicroCapHeadline}                       ${dDifferencePage_Container_MicroCapExhibit} >> .ddiff-animated-exhibit-headline
${dDifferencePage_Text_MicroCapChartTitle}                     .ddiff-micro-cap-chart-title
${dDifferencePage_Text_MicroCapChartGrowth}                    .ddiff-micro-cap-chart-growth
${dDifferencePage_Text_MicroCapDisclosure}                     .ddiff-micro-cap-disclosures
${dDifferencePage_Div_MicroCapChartCircle}                     .ddiff-micro-cap-chart-circle
${dDifferencePage_Div_MicroCapChartStart}                      .micro-cap-svg-FUNDTYPE-start
${dDifferencePage_Div_MicroCapChartEnd}                        .micro-cap-svg-FUNDTYPE-end-content
${dDifferencePage_Div_MicroCapChartFloor}                      [data-view="microcap"]

*** Keywords ***
Verify DDiff Header Banner Video
    Run Keyword And Continue On Failure    Get Attribute    ${dDifferencePage_Source_HeaderBannerVideo} > source    type    !=    ${EMPTY}
    Get Attribute    ${dDifferencePage_Source_HeaderBannerVideo} > source    src     !=    ${EMPTY}


Verify DDiff Eyebrow And Animated Lines
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_HeaderBannerEyebrow}    !=    ${EMPTY}

    ${lines}    Get Elements    ${dDifferencePage_Text_HeaderBannerTextLines}
    FOR    ${index}    ${line}    IN ENUMERATE    @{lines}
        Get Text    ${line}   !=    ${EMPTY}
        Run Keyword If    ${index} == 0    Get Classes    ${line}    validate    any("italic" in v for v in value)
    END


Verify DDiff Mobile Background Image And Poster Image
    Run Keyword And Continue On Failure    Get Attribute    ${dDifferencePage_Thumbnail_HeaderBannerVideo}    src    !=    ${EMPTY}
    Get Attribute    ${dDifferencePage_Source_HeaderBannerVideo}    poster    !=    ${EMPTY}


Check DDiff English Datapoints Count
    Run Keyword And Continue On Failure    Wait For Load State    networkidle
    Run Keyword And Continue On Failure    Scroll To Element    ${dDifferencePage_Container_FastFacts}
    Get Element Count    ${dDifferencePage_Cards_FFDatapoints}    >=    1


Check DDiff Datapoints Icon, Description and Subdescription
    ${slides}    Get Elements    ${dDifferencePage_Cards_FFDatapoints}
    FOR    ${index}    ${slide}    IN ENUMERATE    @{slides}
        Get Attribute    ${slide} >> img    src    !=    ${EMPTY}
        Get Text    ${slide} >> p:first-child    !=    ${EMPTY}
        Run Keyword If    ${index} == 3    Get Text    ${slide} >> ${dDifferencePage_Text_FFDatapointSubdescription}    !=    ${EMPTY}
    END


Check DDiff German Datapoints Count
    IF  '${environment}' == 'production'
        Go To    url=${PUBLIC_SITE_URL}/de-de/d-difference
    ELSE
        Go To    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathDE}
    END
    Get Element Count    ${dDifferencePage_Cards_FFDatapoints}    >=    1


Check Animated Paragraph Text
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_AnimatedParagraph} >> p:first-child    !=    ${EMPTY}
    Get Text    ${dDifferencePage_Text_AnimatedParagraph} >> p:last-child    !=    ${EMPTY}


Check Animated Donut Title, Description and Percentages
    ${donuts}        Get Elements        ${dDifferencePage_Div_AnimatedDonut}
    FOR    ${index}    ${donut}    IN ENUMERATE   @{donuts}
        Run Keyword And Continue On Failure    Get Text    ${donut} >> .animated-donut-title   !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Text    ${donut} >> .donut-description   !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Text    ${donut} >> .animated-donut-inner-text-percentage    matches    ^([0-9]|[1-9][0-9])%$
        Run Keyword If    ${index} == 0    Get Classes    ${donut} >> .animated-donut-percent  validate    any("teal" in v for v in value)
        ...    ELSE        Get Classes    ${donut} >> .animated-donut-percent   validate    any("gray" in v for v in value)
    END


Verify Disclosure and Tooltip
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_AnimatedDonutDisc}   !=    ${EMPTY}
    Click    ${dDifferencePage_Tooltip_AnimatedDonut} >> [data-qa="d-icon-information-expressive"]
    Run Keyword And Continue On Failure    Wait For Load State
    Get Element States    ${dDifferencePage_TooltipWindow_AnimatedDonut}       not contains        hidden
    Run Keyword And Continue On Failure    Get Text   ${dDifferencePage_TooltipWindow_AnimatedDonut}      !=    ${EMPTY}


Check Animated Section Header Text
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Section_AnimatedParagraph} >> span:first-child    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Section_AnimatedParagraph} >> span:first-child    validate    any("italic" in v for v in value)
    IF  '${environment}' == 'production'
        Get Text    ${dDifferencePage_Section_AnimatedParagraph} >> span:last-child    !=    ${EMPTY}
    ELSE
        Get Text    ${dDifferencePage_Section_AnimatedParagraph} >> span:last-child    contains    ${QA_Test_Characterset}
    END


Check Animated Section Header Border
    Get Style        ${dDifferencePage_Section_AnimatedParagraph}    background-color    equals    ${Yellow01}    pseudo_element=:after


Check Split Animated Content Block
    Run Keyword And Continue On Failure    Get Element States    ${dDifferencePage_Container_ResearchInOurDNA}    validate    detached
    Run Keyword And Continue On Failure    Get Element States    ${dDifferencePage_Container_2ndStickyScroll} >> .ddiff-split-paragraph > div:nth-child(2)    validate    visible
    Run Keyword And Continue On Failure    Get Element States    ${dDifferencePage_Container_2ndStickyScroll} >> .ddiff-split-paragraph > div:nth-child(4)    validate    visible
    Run Keyword And Continue On Failure    Scroll To Element    ${dDifferencePage_Container_ResearchInOurDNA}
    Get Element States    ${dDifferencePage_Container_ResearchInOurDNA}    validate     value & visible


Check Research In Our DNA
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Container_ResearchInOurDNA} > .title    !=    ${EMPTY}

    ${tiles}    Get Elements    .tile
    FOR    ${index}    ${tile}     IN ENUMERATE    @{tiles}
        Run Keyword And Continue On Failure    Get Text    ${tile} >> .tile-heading    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Text    ${tile} >> .tile-description    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Style    ${tile} >> .gray-tile    background-color    equals    ${CoolGray04}
        Run Keyword And Continue On Failure    Get Style    ${tile} >> .color-tile    background-color    equals    ${TealShades[${index}]}
    END


Verify Hover and Style for Tooltip
    Run Keyword And Continue On Failure    Wait For Load State       networkidle
    Run Keyword And Continue On Failure    Scroll To Element         ${dDifferencePage_Image_StandaloneTooltip}
    Verify Tooltip Style    ${dDifferencePage_Image_StandaloneTooltip}


Verify Tooltip Disclosure Text
    Click    ${dDifferencePage_Image_StandaloneTooltip}
    Run Keyword And Continue On Failure    Get Element States      ${dDifferencePage_Text_StandaloneTooltipDisclosure}    contains     visible    enabled
    Get Text    ${dDifferencePage_Text_StandaloneTooltipDisclosure}       !=        ${EMPTY}


Check Laureates Exhibit Title and Placard Details
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_LaureatesTitle}    !=    ${EMPTY}

    ${placards}    Get Elements    ${dDifferencePage_Container_Placards}
    FOR     ${placard}     IN     @{placards}
        Run Keyword And Continue On Failure    Get Attribute    ${placard} >> img    src    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Attribute    ${placard} >> img    alt    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Text    ${placard} >> .name    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Text    ${placard} >> .award-and-date    matches    ^[A-Za-z ]+, \\d{4}$
    END


Check Laureates Exhibit Meatball Toggle and Description
    Run Keyword And Continue On Failure    Hover    ${dDifferencePage_Button_LaureatesMeatball} >> .circle
    Run Keyword And Continue On Failure    Get Style    ${dDifferencePage_Button_LaureatesMeatball} >> .circle    fill    ==    ${Poppy01}

    Run Keyword And Continue On Failure    Click    ${dDifferencePage_Button_LaureatesMeatball}
    Run Keyword And Continue On Failure    Check Laureates Toggle and Description States    expanded
    ${descs}    Get Elements    ${dDifferencePage_Text_LaureatesDescription}
    FOR     ${desc}     IN     @{descs}
        Run Keyword And Continue On Failure    Get Text    ${desc}    !=    ${EMPTY}
    END
    Run Keyword And Continue On Failure    Click    ${dDifferencePage_Button_LaureatesMeatball}
    Check Laureates Toggle and Description States    collapsed


Check Laureates Toggle and Description States
    [Arguments]     ${state}

    IF  "${state}" == "expanded"
        Run Keyword And Continue On Failure   Get Style        ${dDifferencePage_Button_LaureatesMeatball}     animation    not contains    ddiffLaureatesButtonPulse   pseudo_element=:after
        Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Button_LaureatesDescription}     contains    expand
        Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Container_LaureatesDescription}     contains    expand
        Run Keyword And Continue On Failure    Get Style    ${dDifferencePage_Container_LaureatesDescription} > div:first-child    opacity == 1
    ELSE IF  "${state}" == "collapsed"
        Run Keyword And Continue On Failure   Get Style        ${dDifferencePage_Button_LaureatesMeatball}     animation    contains    ddiffLaureatesButtonPulse   pseudo_element=:before
        Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Button_LaureatesDescription}     contains    collapse
        Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Container_LaureatesDescription}     contains    collapse
        Run Keyword And Continue On Failure    Get Style    ${dDifferencePage_Container_LaureatesDescription} > div:first-child    opacity == 0
    END


Verify Infographic Headline, Tooltip and Disclosure
    Run Keyword And Continue On Failure    Wait For Load State    networkidle
    Run Keyword And Continue On Failure    Scroll To Element    ${dDifferencePage_Container_OutperformedExhibit}
    Run Keyword And Continue On Failure    Wait For Elements State   ${dDifferencePage_Container_OutperformedExhibit} >> .ddiff-animated-exhibit-headline     stable
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Container_OutperformedExhibit} >> .ddiff-animated-exhibit-headline       !=    ${EMPTY}
    Get Style        ${dDifferencePage_Container_OutperformedExhibit} >> .ddiff-animated-exhibit-border     background-color    equals    ${Poppy01}    pseudo_element=:after
    Run Keyword And Continue On Failure    Get Text   .ddiff-outperformed-disclosures-show    !=    ${EMPTY}
    Get Element States      ${dDifferencePage_Container_OutperformedExhibit} >> [data-qa="d-icon-information-expressive"]    contains     visible    enabled


Verify Outperformed Charts

    Run Keyword And Continue On Failure    Get Text   ${dDifferencePage_Text_OutperformedChartsTitle}    !=    ${EMPTY}
    ${charts}    Get Elements    ${dDifferencePage_Div_OutperformedCharts}
    FOR     ${chart}     IN     @{charts}
        Run Keyword And Continue On Failure    Get Text    ${chart} >> .ddiff-outperformed-chart-year    !=    ${EMPTY}
        ${graphs}        Get Elements    ${chart} >> .ddiff-outperformed-chart-graph
        FOR    ${graph}    IN    @{graphs}
            Run Keyword And Continue On Failure    Get Text    ${graph} >> .ddiff-outperformed-chart-text    !=    ${EMPTY}
            ${graph_labels}    Get Elements    ${graph} >> .ddiff-outperformed-chart-graph-labels
            FOR    ${graph_label}    IN    @{graph_labels}
                Run Keyword And Continue On Failure    Get Text    ${graph_label} >> .ddiff-outperformed-chart-graph-labels-text    !=    ${EMPTY}
                Run Keyword And Continue On Failure    Get Text    ${graph_label} >> .ddiff-outperformed-chart-graph-labels-numbers   matches    ^([0-9]|[1-9][0-9])%$
            END
        END
    END

    ${first_graph}    Get Element    (//div[@class="ddiff-outperformed-chart-graphs"])[1]
    Run Keyword And Continue On Failure    Get style    ${first_graph} >> .ddiff-outperformed-chart-graph-color    background    contains     ${Teal03}
    Run Keyword And Continue On Failure    Get style    ${first_graph} >> .ddiff-outperformed-chart-graph-bar    background-color    ==     ${CoolGray04}
    Run Keyword And Continue On Failure    Get style    ${first_graph} >> div.ddiff-outperformed-chart-graph-dots-one >> svg    stroke    ==    ${AlmostBlack}
    ${second_graph}    Get Element    (//div[@class="ddiff-outperformed-chart-graphs"])[2]
    Run Keyword And Continue On Failure    Get style    ${second_graph} >> .ddiff-outperformed-chart-graph-color    background   contains     ${Yellow02}
    Run Keyword And Continue On Failure    Get style    ${second_graph} >> div.ddiff-outperformed-chart-graph-dots-two >> svg    stroke    ==    ${CoolGray03}
    Run Keyword And Continue On Failure    Get style    ${second_graph} >> .ddiff-outperformed-chart-graph-bar    background-color    ==     ${CoolGray04}


Check Premiums Infographic Headline And Title
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_PremiumsHeadline}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_PremiumsTitle}    !=    ${EMPTY}
    Get Style    ${dDifferencePage_Style_PremiumsHeadline}    background-color    equals    ${Poppy01}    pseudo_element=:after


Check Premiums Toggle Switch
    Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Label_PremiumsToggleLabelEquity}    validate    any("poppy" in v for v in value)
    Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Label_PremiumsToggleLabelFixed}    validate    any("poppy" not in v for v in value)
    Run Keyword And Continue On Failure    Get Style    ${dDifferencePage_Style_PremiumsToggleAnimation}    animation    contains    pulse-animation    pseudo_element=:before

    Run Keyword And Continue On Failure    Click    ${dDifferencePage_Checkbox_PremiumsToggle}

    Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Label_PremiumsToggleLabelFixed}    validate    any("poppy" in v for v in value)
    Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Label_PremiumsToggleLabelEquity}    validate    any("poppy" not in v for v in value)
    Get Style    ${dDifferencePage_Style_PremiumsToggleAnimation}    animation    contains    pulse-animation    pseudo_element=:before


Check Premiums Cards
    ${toggle_states}    Get Element States    ${dDifferencePage_Checkbox_PremiumsToggle} > input
    ${cards}    Get Elements    ${dDifferencePage_Section_PremiumsCharts}

    FOR  ${index}    ${card}  IN ENUMERATE  @{cards}
        IF  "checked" not in @{toggle_states}
            IF    ${index} < 3
                Check Premium Cards Presence    ${card}    equity
            ELSE
                Check Premium Cards Absence    ${card}    fixed
            END
        ELSE
            IF    ${index} < 3
                Check Premium Cards Absence    ${card}    equity
            ELSE
                Check Premium Cards Presence    ${card}    fixed
            END
        END
    END


Check Premium Cards Presence
    [Arguments]     ${card}    ${card_type}
    Run Keyword And Continue On Failure    Get Text    ${card} >> .ddiff-${card_type}-copy    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style    ${card} >> .ddiff-${card_type}-copy    opacity == 1
    Run Keyword And Continue On Failure    Get Attribute    ${card} >> .ddiff-${card_type}-svg >> img    src    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${card} >> .ddiff-${card_type}-svg >> img    alt    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${card} >> .ddiff-${card_type}-svg    validate    any("hide" not in v for v in value)


Check Premium Cards Absence
    [Arguments]     ${card}    ${card_type}
    Run Keyword And Continue On Failure    Get Style    ${card} >> .ddiff-${card_type}-svg    opacity == 0
    Run Keyword And Continue On Failure    Get Classes    ${card} >> .ddiff-${card_type}-copy    validate    any("show" not in v for v in value)


Check Quote Symbol, Text, Name and Title
    Run Keyword And Continue On Failure    Get Style    ${dDifferencePage_Symbol_QuoteBlock}    fill    ==    ${Yellow01}
    Run Keyword And Continue On Failure    Get Attribute    ${dDifferencePage_Symbol_QuoteBlock}    d    matches    ^M.*C.*L.*Z$

    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_Quote}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style    ${dDifferencePage_Text_Quote}    color    ==    ${CoolGray02}
    Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Text_Quote}    validate    any("italic" in v for v in value)

    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_QuoteName}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style    ${dDifferencePage_Text_QuoteName}    color    ==    ${CoolGray02}

    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_QuoteTitle}    !=    ${EMPTY}
    Get Style    ${dDifferencePage_Text_QuoteTitle}    color    ==    ${CoolGray02}


Verify Title and 3 Sections of Lottie
    Run Keyword And Continue On Failure    Get Style        ${dDifferencePage_Div_BestOfBothContainer}         background-color    ==    ${CoolGray01}
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Div_BestOfBothContainer}>div:first-child    !=    ${EMPTY}
    FOR  ${index}  IN RANGE  2  7  2
        Run Keyword And Continue On Failure   Get Text    ${dDifferencePage_Text_BestOfBothSectionTitle}:nth-of-type(${index-1})    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Text_BestOfBothSectionTitle}:nth-of-type(${index-1})    validate    any("white" in v for v in value)
        Run Keyword And Continue On Failure   Get Text    ${dDifferencePage_Text_BestOfBothSectionSub}:nth-of-type(${index})    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Text_BestOfBothSectionSub}:nth-of-type(${index})    validate    any("white" in v for v in value)
        ${mobile_items}    Get Elements    ${dDifferencePage_List_BestOfBothSectionAchievements}:nth-of-type(${index//2}) > li
        FOR    ${mobile_item}    IN    @{mobile_items}
            Run Keyword And Continue On Failure   Get Text    ${mobile_item}    !=    ${EMPTY}
            Run Keyword And Continue On Failure    Get Classes    ${mobile_item} >> div    validate    set(${Lottie_AchievementsColors}).intersection(value)
        END

    END



Verify Infographic Headline, Chart Title with Growth & Disclosure
    Run Keyword And Continue On Failure    Scroll To Element    ${dDifferencePage_Container_MicroCapExhibit}
    Run Keyword And Continue On Failure    Wait For Elements State   ${dDifferencePage_Text_MicroCapHeadline}     stable
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_MicroCapHeadline}      !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style        ${dDifferencePage_Container_MicroCapExhibit} >> .ddiff-animated-exhibit-border     background-color    equals    ${Poppy01}    pseudo_element=:after
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_MicroCapChartTitle}      !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Text    ${dDifferencePage_Text_MicroCapChartGrowth}       matches    ^.*\\$.*\\d{4}—\\d{4}$
    Run Keyword And Continue On Failure    Get Text   ${dDifferencePage_Text_MicroCapDisclosure}     !=    ${EMPTY}
    Get Element States      ${dDifferencePage_Container_MicroCapExhibit} >> [data-qa="d-icon-information-expressive"]     contains     visible    enabled


Verify Microcap Chart Circle and Graph
    Run Keyword And Continue On Failure    Wait For Elements State   ${dDifferencePage_Div_MicroCapChartCircle}    stable
    Run Keyword And Continue On Failure    Get Text   ${dDifferencePage_Div_MicroCapChartCircle}       !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style        ${dDifferencePage_Div_MicroCapChartCircle}      background-color    equals    ${WarmGray06}
    Run Keyword And Continue On Failure    Get Classes    ${dDifferencePage_Div_MicroCapChartCircle}>div       validate    any("teal" in v for v in value)
    ${index_start}    Run Keyword And Continue On Failure    Get Text     ${dDifferencePage_Div_MicroCapChartStart.replace("FUNDTYPE","index")}   matches     ^\\$\\d+
    Run Keyword And Continue On Failure    Get Text     ${dDifferencePage_Div_MicroCapChartStart.replace("FUNDTYPE","fund")}   ==     ${index_start}
    Run Keyword And Continue On Failure   Verify Micro Cap End Content        index      ${CoolGray01}
    Run Keyword And Continue On Failure   Verify Micro Cap End Content        fund       ${Teal01}
    Get Style     [data-view="microcap"]    transform-style    ==     preserve-3d


Verify Micro Cap End Content
    [Arguments]        ${fund_type}    ${color}
    Run Keyword And Continue On Failure    Get Style        ${dDifferencePage_Div_MicroCapChartStart.replace("FUNDTYPE","${fund_type}")}>div>svg>circle       fill     ==    ${color}
    ${end_contents}        Get Elements        ${dDifferencePage_Div_MicroCapChartEnd.replace("FUNDTYPE","${fund_type}")}>p
    FOR    ${idx}    ${end_content}    IN ENUMERATE    @{end_contents}
        	IF    ${idx} == 0
                Run Keyword And Continue On Failure    Get Text   ${end_content}       !=    ${EMPTY}
                Run Keyword And Continue On Failure    Get Classes    ${end_content}      validate    any("cool-gray" in v for v in value)
            ELSE IF    ${idx} == 1
                Run Keyword And Continue On Failure    Get Text   ${end_content}     matches     ^\\$\\d+
                Run Keyword And Continue On Failure    Get Style     ${end_content}      color    ==     ${color}
            ELSE
                Run Keyword And Continue On Failure    Get Text   ${end_content}       *=    %
                Run Keyword And Continue On Failure    Get Style     ${end_content}      color    ==     ${color}
            END

    END
    Run Keyword And Continue On Failure    Get Attribute     .micro-cap-svg-${fund_type}   viewBox    !=     ${EMPTY}

Verify Tooltip Style
    [Arguments]    ${locator}
    Run Keyword And Continue On Failure   Get Style    ${locator}    color    ==    ${CoolGray800}
    Run Keyword And Continue On Failure    Hover    ${locator}
    Wait For Condition    Style    ${locator}    color    ==    ${Teal900}
