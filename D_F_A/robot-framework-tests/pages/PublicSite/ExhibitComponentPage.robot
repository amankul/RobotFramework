*** Variables ***
${ExhibitComponentPage_Container_InlineExhibit}                [data-qa="inline-exhibit"]
${ExhibitComponentPage_Text_InlineExhibitTitle}                [data-qa="inline-exhibit-main-title"]
${ExhibitComponentPage_Text_InlineExhibitSubTitle}             [data-qa="inline-exhibit-subtitle"]
${ExhibitComponentPage_Text_InlineExhibitDescription}          [data-qa="inline-exhibit-description"]
${ExhibitComponentPage_Text_InlineExhibitDisclosure}           [data-qa="inline-exhibit-disclosure-text"]
${ExhibitComponentPage_Button_InlineExhibitTooltip}            [data-qa="button-icon-info-popup"]
${ExhibitComponentPage_Text_InlineExhibitTooltipText}          [data-id="tooltip"]
${ExhibitComponentPage_Image_InlineExhibitImage}               [data-qa="inline-exhibit-image"]
${ExhibitComponentPage_Modal_InlineExhibitPopupModal}          [data-qa="inline-exhibit-image-modal"]
${ExhibitComponentPage_Modal_InlineExhibitPopupModalImage}     [data-qa="inline-exhibit-image-in-modal"]
${ExhibitComponentPage_Button_InlineExhibitPopupModalClose}    [data-qa="button-icon-close"]
${ExhibitComponentPage_Text_ScrollExhibitTitle}                [data-qa="scroll-exhibit-title"]
${ExhibitComponentPage_Text_ScrollExhibitSlideText}            [data-qa="scroll-exhibit-content"]
${ExhibitComponentPage_Image_ScrollExhibitSlideImage}          [data-qa="scroll-exhibit-backdrop-image"]
${ExhibitComponentPage_Button_ScrollExhibitLittlei}            [data-qa="d-icon-information-expressive"]

*** Keywords ***
Verify Inline Exhibit
    Wait For Load State    networkidle
    Run Keyword And Continue On Failure    Get Classes    ${ExhibitComponentPage_Container_InlineExhibit}    validate    any("--border-top" in v for v in value)
    Run Keyword And Continue On Failure    Get Classes    ${ExhibitComponentPage_Container_InlineExhibit} > div:last-child    validate    any("--border-bottom" in v for v in value)
    Run Keyword And Continue On Failure    Get Text    ${ExhibitComponentPage_Text_InlineExhibitTitle}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Text    ${ExhibitComponentPage_Text_InlineExhibitSubTitle}     !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${ExhibitComponentPage_Text_InlineExhibitSubTitle}    validate    any("italic" in v for v in value)
    Run Keyword And Continue On Failure    Get Text    ${ExhibitComponentPage_Text_InlineExhibitDescription}    equals    ${QA_Test_Characterset}
    Run Keyword And Continue On Failure    Get Text    ${ExhibitComponentPage_Text_InlineExhibitDisclosure}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style    ${ExhibitComponentPage_Text_InlineExhibitTooltipText}    visibility    equals    hidden
    Run Keyword And Continue On Failure    Hover    ${ExhibitComponentPage_Button_InlineExhibitTooltip}
    Run Keyword And Continue On Failure    Get Style    ${ExhibitComponentPage_Text_InlineExhibitTooltipText}    visibility    equals    visible
    Run Keyword And Continue On Failure    Get Text    ${ExhibitComponentPage_Text_InlineExhibitTooltipText}    contains    ${QA_Test_Characterset}
    ${image_src}    Run Keyword And Continue On Failure    Get Attribute    ${ExhibitComponentPage_Image_InlineExhibitImage}    src    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Element States    ${ExhibitComponentPage_Modal_InlineExhibitPopupModal}    contains    detached
    Run Keyword And Continue On Failure    Click    ${ExhibitComponentPage_Image_InlineExhibitImage}
    Run Keyword And Continue On Failure    Get Element States    ${ExhibitComponentPage_Modal_InlineExhibitPopupModal}    contains    attached
    Run Keyword And Continue On Failure    Get Attribute    ${ExhibitComponentPage_Modal_InlineExhibitPopupModalImage}    src    equals    ${image_src}
    Run Keyword And Continue On Failure    Click    ${ExhibitComponentPage_Button_InlineExhibitPopupModalClose}
    Get Element States    ${ExhibitComponentPage_Modal_InlineExhibitPopupModal}    contains    detached


Verify Scroll Exhibit
    Run Keyword And Continue On Failure    Scroll To Element    ${ExhibitComponentPage_Text_ScrollExhibitTitle}
    ${slide_texts}    Run Keyword And Continue On Failure    Get Elements    ${ExhibitComponentPage_Text_ScrollExhibitSlideText}
    ${slide_images}    Run Keyword And Continue On Failure    Get Elements    ${ExhibitComponentPage_Image_ScrollExhibitSlideImage}
    FOR  ${i}  IN RANGE  len(${slide_texts})
        Run Keyword And Continue On Failure    Scroll By    vertical=40%
        ${new_position}    Run Keyword And Continue On Failure    Get BoundingBox    ${slide_texts}[${i}]    y
        Run Keyword And Continue On Failure    Should Be True    ${new_position} < 0
        Run Keyword And Continue On Failure    Get Attribute    ${slide_images}[${i}]    src    !=    ${EMPTY}
    END
    Verify Tooltip Style    ${ExhibitComponentPage_Button_ScrollExhibitLittlei}