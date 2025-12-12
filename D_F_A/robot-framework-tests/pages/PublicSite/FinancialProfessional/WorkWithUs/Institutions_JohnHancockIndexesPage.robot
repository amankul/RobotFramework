*** Variables ***

${JohnHancockIndexes_Link_DocumentLinks}    a[href*='/media/d']

*** Keywords ***

Evaluate Random Document
    [Documentation]     Load a random document pdf
    ${locators}         Get Elements       ${JohnHancockIndexes_Link_DocumentLinks}
    ${random_locator}     Evaluate  random.choice($locators)
    ${random_link}     Get Property     ${random_locator}     href
    Log	     Verifying PDF at ${random_link}        console=True
    Load-As-Web-Service        ${random_link}