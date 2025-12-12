# This is the page object for the following pages:
# "us-en/dev-lab/qa-test-pages/remembrance-page-portrait"
# "us-en/dev-lab/qa-test-pages/remembrance-page-silhouette"

*** Variables ***
${RemembranceModalPage_Container_Modal}              [data-qa="homepage-remembrance-modal-content"]
${RemembranceModalPage_Attribute_Image}              [data-qa="homepage-remembrance-modal-image"]
${RemembranceModalPage_Attribute_BackgroundImage}    [data-qa="homepage-remembrance-modal-background-image"]
${RemembranceModalPage_Text_Name}                    [data-qa="homepage-remembrance-modal-name"]
${RemembranceModalPage_Text_Lifespan}                [data-qa="homepage-remembrance-modal-lifespan"]
${RemembranceModalPage_Style_Eyebrow}                [data-qa="homepage-remembrance-modal-eyebrow"]
${RemembranceModalPage_Text_Title}                   [data-qa="homepage-remembrance-modal-title"]
${RemembranceModalPage_Text_Description}             [data-qa="homepage-remembrance-modal-description"]
${RemembranceModalPage_Link_CTA}                     [data-qa="homepage-remembrance-modal-bio-link"]
${RemembranceModalPage_Button_Close}                 [data-qa="homepage-remembrance-modal-close"]


*** Keywords ***
Check Remembrance Modal Container, Image, Background Image, Name and Lifespan
    Run Keyword And Continue On Failure    Get Element States    ${RemembranceModalPage_Container_Modal}    contains    attached

    Run Keyword And Continue On Failure    Get Attribute    ${RemembranceModalPage_Attribute_Image}    src    !=    ${EMPTY}
    IF  'Portrait' in '${TEST_NAME}'
        Run Keyword And Continue On Failure    Get Style    ${RemembranceModalPage_Attribute_BackgroundImage}    background-image    contains    svg
    ELSE IF  'Silhouette' in '${TEST_NAME}'
        Run Keyword And Continue On Failure    Get Style    ${RemembranceModalPage_Attribute_BackgroundImage}    background-image    validate    any(v in value for v in @{Image_Extensions})
    END

    Run Keyword And Continue On Failure    Get Text    ${RemembranceModalPage_Text_Name}    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Style    ${RemembranceModalPage_Text_Name}    color    ==    ${CoolGray01}
    Run Keyword And Continue On Failure    Get Classes    ${RemembranceModalPage_Text_Name}    contains    t-label-sm-heavy

    Run Keyword And Continue On Failure    Get Text    ${RemembranceModalPage_Text_Lifespan}    ==    1950-2000
    Run Keyword And Continue On Failure    Get Style    ${RemembranceModalPage_Text_Lifespan}    color    ==    ${CoolGray01}
    Run Keyword And Continue On Failure    Get Classes    ${RemembranceModalPage_Text_Lifespan}    contains    t-label-sm-heavy


Check Remembrance Modal Eyebrow, Title and Description
    Run Keyword And Continue On Failure    Get Style    ${RemembranceModalPage_Style_Eyebrow}    background-color    ==    ${Yellow01}

    Run Keyword And Continue On Failure    Get Text    ${RemembranceModalPage_Text_Title} > p:first-child    !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Classes    ${RemembranceModalPage_Text_Title} > p:first-child    contains    t-heading-xxl
    Run Keyword And Continue On Failure    Get Style    ${RemembranceModalPage_Text_Title} > p:first-child    color    ==    ${AlmostBlack}

    Run Keyword And Continue On Failure    Get Text    ${RemembranceModalPage_Text_Title} > p:last-child    ==    John Doe
    Run Keyword And Continue On Failure    Get Classes    ${RemembranceModalPage_Text_Title} > p:last-child    contains    t-heading-xxl-italic
    Run Keyword And Continue On Failure    Get Style    ${RemembranceModalPage_Text_Title} > p:last-child    color    ==    ${AlmostBlack}

    Run Keyword And Continue On Failure    Get Text    ${RemembranceModalPage_Text_Description}    contains    ${QA_Test_Characterset}
    Run Keyword And Continue On Failure    Get Classes    ${RemembranceModalPage_Text_Description}    contains    t-body-md
    Run Keyword And Continue On Failure    Get Style    ${RemembranceModalPage_Text_Description}    color    ==    ${CoolGray01}


Check Remembrance Modal CTA, GA Attributes and Close Button
    Run Keyword And Continue On Failure    Get Text    ${RemembranceModalPage_Link_CTA}   !=    ${EMPTY}
    Run Keyword And Continue On Failure    Get Attribute    ${RemembranceModalPage_Link_CTA}    data-a-comp    ==    Remembrance Modal

    IF  'Portrait' in '${TEST_NAME}'
        Run Keyword And Continue On Failure    Get Classes    ${RemembranceModalPage_Link_CTA}    contains    secondary-standalone-external-link
    ELSE IF  'Silhouette' in '${TEST_NAME}'
        Run Keyword And Continue On Failure    Get Classes    ${RemembranceModalPage_Link_CTA}    contains    primary-standalone-caret-link
    END

    ${link}    Run Keyword And Continue On Failure    Get Attribute    ${RemembranceModalPage_Link_CTA}    href
    Run Keyword And Continue On Failure    Click    ${RemembranceModalPage_Link_CTA}
    Run Keyword And Continue On Failure    Wait For Condition    Url    ^=    ${link}
    Run Keyword And Continue On Failure    Go Back

    Run Keyword And Continue On Failure    Click    ${RemembranceModalPage_Button_Close}
    Get Element States    ${RemembranceModalPage_Container_Modal}    contains    detached