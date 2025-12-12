*** Variables ***
${InstitutionsPage_Media_StrategiesGraphic}            \#page-strategies-viz-inline
${InstitutionsPage_Text_GraphicTitle}                  .strategies-title
${InstitutionsPage_Text_GraphicDescription}            .strategies-desc
${InstitutionsPage_Text_GraphicSubdescription}         .strategies-sub-desc
${InstitutionsPage_Button_StandAloneMeatball}          [data-a-comp="Meatball CTA"]
${InstitutionsPage_Container_StaticTextImageHeader}    .header-static-text-image-container

*** Keywords ***
Check Strategies Graphic Title, Description and Sub-description
    Run Keyword And Continue On Failure    Get Text    ${InstitutionsPage_Text_GraphicTitle}    !=     ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${InstitutionsPage_Text_GraphicTitle}    contains    t-heading-xl
    Run Keyword And Continue On Failure    Get Style    ${InstitutionsPage_Text_GraphicTitle}    color    ==    ${CoolGray01}
    Run Keyword And Continue On Failure    Get Text    ${InstitutionsPage_Text_GraphicDescription}    !=     ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${InstitutionsPage_Text_GraphicDescription}    contains    t-body-md
    Run Keyword And Continue On Failure    Get Style    ${InstitutionsPage_Text_GraphicDescription}    color    ==    ${AlmostBlack}
    Run Keyword And Continue On Failure    Get Text    ${InstitutionsPage_Text_GraphicSubdescription}    !=     ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${InstitutionsPage_Text_GraphicSubdescription}    contains    t-body-xs
    Run Keyword And Continue On Failure    Get Style    ${InstitutionsPage_Text_GraphicSubdescription}    color    ==    ${AlmostBlack}


Check Strategies Graphic Background Color
    # All the shades of gray background in this component are custom colors and hence
    # not adding them to our color library static set of values.
    ${polygons}    Get Elements    ${InstitutionsPage_Media_StrategiesGraphic} >> polygon
    FOR    ${index}    ${polygon}    IN ENUMERATE    @{polygons}
        ${color}    Get Style    ${polygon}    fill
        IF    ${index} < 7
            Run Keyword And Continue On Failure    Should Be True    "${color}" == "rgba(5, 5, 3, 0.1)"
        ELSE IF    (${index} > 8 and ${index} % 2 == 1)
            Run Keyword And Continue On Failure    Should Be True    "${color}" == "none"
        ELSE
            Run Keyword And Continue On Failure    Should Match Regexp    ${color}    ^rgba\\(5, 5, 3, 0.
        END
    END


Check Strategies Graphic Subgroup Title and Hover
    ${subgroups}    Get Elements    ${InstitutionsPage_Media_StrategiesGraphic} >> .subgroup
    FOR  ${subgroup}  IN  @{subgroups}
        Run Keyword And Continue On Failure    Get Property    ${subgroup} >> .title    textContent    !=    ${EMPTY}
        Run Keyword And Continue On Failure    Get Style    ${subgroup} >> .title    fill    ==    ${White}
        Run Keyword And Continue On Failure    Hover    ${subgroup} >> .main-text
        Run Keyword And Continue On Failure    Get Style    ${subgroup} >> .main-text    fill    ==    ${Yellow03}
        Run Keyword And Continue On Failure    Get Style    ${subgroup} >> .title    fill    ==    ${CoolGray00}
        Run Keyword And Continue On Failure    Get Text    .desc    !=    ${EMPTY}
    END


Check Meatball Hover, Navigation and GA Attributes
    Run Keyword And Continue On Failure    Get Style   ${InstitutionsPage_Button_StandAloneMeatball} >> .circle    fill    ==    ${Poppy01}
    Run Keyword And Continue On Failure   Hover    ${InstitutionsPage_Button_StandAloneMeatball} >> .circle
    Run Keyword And Continue On Failure    Get Style   ${InstitutionsPage_Button_StandAloneMeatball} >> .circle    fill    ==    ${CoolGray01}
    Run Keyword And Continue On Failure    Get Text    ${InstitutionsPage_Button_StandAloneMeatball} >> .link-text    !=    ${EMPTY}
    ${link}    Run Keyword And Continue On Failure    Get Attribute    ${InstitutionsPage_Button_StandAloneMeatball}    href
    Run Keyword And Continue On Failure    Click    ${InstitutionsPage_Button_StandAloneMeatball}
    Wait For Condition    Url   equals    ${link}


Check Static Text Image Header Eyebrow, Title and Accent Bar
    Run Keyword And Continue On Failure    Get Text    ${InstitutionsPage_Container_StaticTextImageHeader} >> .eyebrow    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${InstitutionsPage_Container_StaticTextImageHeader} >> .eyebrow    contains    t-title-label-heavy
    Run Keyword And Continue On Failure    Get Style    ${InstitutionsPage_Container_StaticTextImageHeader} >> .eyebrow    color    equals    ${CoolGray01}
    Run Keyword And Continue On Failure    Get Text    ${InstitutionsPage_Container_StaticTextImageHeader} >> .title    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${InstitutionsPage_Container_StaticTextImageHeader} >> .title    contains    t-title-sm
    Run Keyword And Continue On Failure    Get Style    ${InstitutionsPage_Container_StaticTextImageHeader} >> .title    color    equals    ${AlmostBlack}
    Run Keyword And Continue On Failure    Get Property    ${InstitutionsPage_Container_StaticTextImageHeader} >> .title    localName    equals    h1
    Run Keyword And Continue On Failure    Get Style    ${InstitutionsPage_Container_StaticTextImageHeader} >> .title-content >> div:first-child    background-color    equals    ${Poppy01}

Check Static Text Image Header Theme and Background Image
    Run Keyword And Continue On Failure    Get Classes    ${InstitutionsPage_Container_StaticTextImageHeader}    contains    theme-B
    Run Keyword And Continue On Failure    Get Attribute    ${InstitutionsPage_Container_StaticTextImageHeader} >> source:first-child    srcset    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${InstitutionsPage_Container_StaticTextImageHeader} >> source:nth-child(2)    srcset    !=    ${EMPTY}
    Get Attribute    ${InstitutionsPage_Container_StaticTextImageHeader} >> img    src    !=${EMPTY}