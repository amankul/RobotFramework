*** Variables ***

${NewsroomPage_Banner_MediaContacts}    .media-contacts

*** Keywords ***

Check Media Contacts
    [Documentation]     Check if the media contacts banner is displayed for a given country.
    Wait For Condition    Element States    ${NewsroomPage_Banner_MediaContacts}    contains    visible
