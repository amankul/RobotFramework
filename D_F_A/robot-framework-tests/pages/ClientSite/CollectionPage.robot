# This is page object for "dev-lab/qa-test-pages/qa-collection-page"

*** Variables ***
${CollectionPage_Text_CollectionHeader}     [id="NavigatetoPlaceholderHeader"]
${CollectionPage_Text_CollectionCardTitle}    [data-a-name="Test Content Card Placeholder"]

*** Keywords ***
Check Personalized Collection Section Headers
    [Arguments]    ${country_audience}    ${header_visibility}
    Get Element States    ${CollectionPage_Text_CollectionHeader.replace('Placeholder','${country_audience}')}    contains    ${header_visibility}


Check Personalized Collection Card Headers
    [Arguments]    ${card}    ${card_visibility}
    Get Element States    ${CollectionPage_Text_CollectionCardTitle.replace('Placeholder','${card}')}    contains    ${card_visibility}