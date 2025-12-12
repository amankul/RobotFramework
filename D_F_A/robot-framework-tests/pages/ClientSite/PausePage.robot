*** Variables ***

${PausePage_Button_Continue}            [data-qa="pause-page-continue-button"]
${PausePage_Link_Return}                [data-qa="pause-page-return-link"]:first-child
# the below element exists on social cost of carbon cms page which links to pause page
${PausePage_Link_SocialCostOfCarbon}    [aria-label*="nature"]

*** Keywords ***

Navigation BacknForth From Pause Page
    [Documentation]  Verify one can open,navigate back and forth the pause page.
    ${url}      Get Url
    ${ext_page}       Get Attribute           ${PausePage_Link_SocialCostOfCarbon}      data-a-name
    Run Keyword And Continue On Failure     Wait For Function      element => element.href.includes("/pause?")      selector=${PausePage_Link_SocialCostOfCarbon}
    Click       ${PausePage_Link_SocialCostOfCarbon}
    Switch Page      NEW
    Wait For Elements State        ${HomePage_Image_Logo}        visible
    Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
    Click       ${PausePage_Link_Return}
    Run Keyword And Continue On Failure     Get Url     ==      ${url}
    Run Keyword And Continue On Failure     Wait For Function      element => element.href.includes("/pause?")      selector=${PausePage_Link_SocialCostOfCarbon}
    Click       ${PausePage_Link_SocialCostOfCarbon}
    Switch Page      NEW
    Click           ${PausePage_Button_Continue}
    Switch Page      NEW
    Get Url     ==       ${ext_page}