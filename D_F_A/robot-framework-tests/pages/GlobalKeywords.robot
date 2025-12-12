*** Settings ***

Library    Browser    timeout=60s
Library    Collections
Library    DateTime
Library    OperatingSystem
Library    JSONLibrary
Library    RequestsLibrary
Library    String
Library    ../scripts/yamlreader.py
Library    ../scripts/excelreader.py

*** Keywords ***

Initialize Browser
    Set Test Variable     &{browser_opt}      browser=${browserlib}       headless=True
    Set Test Variable     &{context_opt}      userAgent=dimobot    extraHTTPHeaders=None


New Browser Context and Page
    [Arguments]    ${browser_options}     ${context_options}        ${url}=about:blank
    [Documentation]    Open given url in new browser context using Browser Lib
    Run Keyword And Continue On Failure     New Browser     &{browser_options}
    Run Keyword And Continue On Failure     New Context     &{context_options}
    New Page        ${url}


Random String
    [Arguments]    ${locator}    ${length}
    [Documentation]    Generates are random string of ${length} characters and enters it into ${locator}.
    ...    Contains Upper and Lower case letters as well as numbers.
    ...    .
    ${string}    Generate Random String    ${length}    [LETTERS][NUMBERS][UPPER][LOWER]
    Fill Text    ${locator}    ${string}


Random Numbers
    [Arguments]    ${locator}    ${length}
    [Documentation]    Generates are random string of ${length} characters and enters it into ${locator}.
    ...    Contains Upper and Lower case letters as well as numbers.
    ...    .
    ${string}    Generate Random String    ${length}    [NUMBERS]
    Fill Text    ${locator}    ${string}


Load-As-Web-Service
    [Arguments]         ${url}    ${param}=${EMPTY}
    [Documentation]     Loads the given url as an HTTP GET call using a test parameter e.g. 'testOnly=true'.
    ...                 This will respond with a limited body and reduce the overall time taken for the test.

    Create Session    api    ${url}    disable_warnings=1
    ${response}    GET On Session    api    ${url}    params=${param}
    Status Should Be    OK    ${response}
    RETURN       ${response}


Get Days Difference
    [Arguments]     ${date}     ${format}
    [Documentation]     Substract date in given format from current date
    ${current_date} 	Get Current Date	result_format=${format}
    ${diff_sec}= 	Subtract Date From Date	    ${current_date}	    ${date}     date1_format=${format}       date2_format=${format}
    Run Keyword And Return      Evaluate    ${diff_sec}/${Seconds_in_Day}


Ensure Data Appears In Grid
    [Arguments]     ${locator}
    [Documentation]     Given locator for all values in grid, verify these values are not empty
    @{elements}       Get Elements     ${locator}
    FOR     ${element}   IN     @{elements}
            Run Keyword And Continue On Failure     Get Text    ${element}     validate           value.strip()
    END


Get-Credentials
    [Documentation]    Gets d AD  user info and saves as global variable that tests can consume
    Log      Suite setup to get credentials     console=True
    Set Log Level    NONE
    Set Suite Variable  ${CREDS}     {'username': '$AD_Username', 'password':'$AD_Password'}
    Set Log Level    INFO
    ${browserlib} 	    Set Variable If	    '${browser}' in ['chrome', 'edge']	    chromium        ${browser}
    Set Suite Variable	    ${browserlib}


Download Given Document
    [Documentation]    Creates a promise to dowload and waits for completion.
    [Arguments]         ${doc_link}
    ${dl_promise}        Promise To Wait For Download
    Click                ${doc_link}
    Run Keyword And Return           Wait For      ${dl_promise}


Load Yaml
        [Arguments]         ${file_path}
        [Documentation]     Return Yaml at given path
        ${yaml_data}     yamlreader.read yaml file      ${file_path}
        RETURN        ${yaml_data}


Wait For Page To Stop Scrolling
    Evaluate JavaScript    .content-page    () => {
        ...    let last_changed_frame = 0
        ...    let last_x = window.scrollX
        ...    let last_y = window.scrollY
        ...    return new Promise( resolve => {
        ...    function tick(frames) {
        ...        if (frames >= 500 || frames - last_changed_frame > 20) {
        ...            resolve()
        ...        } else {
        ...            if (window.scrollX != last_x || window.scrollY != last_y) {
        ...                last_changed_frame = frames
        ...                last_x = window.scrollX
        ...                last_y = window.scrollY
        ...            }
        ...            requestAnimationFrame(tick.bind(null, frames + 1))
        ...        }
        ...    }
        ...    tick(0)
        ...    })
        ...    }


Verify Footer Links
    Log    Verifying Footers    console=True
    Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True

    ${footers}    Get Elements    ${HomePage_Links_Footer}
    FOR  ${footer}  IN  @{footers}
        ${link}    Get Attribute    ${footer}    href
        ${link_text}    Get Property    ${footer}    innerText
        Log    ${link_text} : ${link}    console=True
        IF  'pdf' in '${link}'
            ${file_obj}    Download Given Document    ${footer}
            Should Be True    '${file_obj}[suggestedFilename][:10]' in '${link}'
        ELSE IF  '${link}' == '${EMPTY}'
                Reload    # Intentionally removed the one trust confirm button validation as it is giving intermittent failures. Waits not working consistently.
        ELSE
            ${Current_Page}    Get Page Ids    CURRENT
            Run Keyword And Continue On Failure    Click    ${footer}
            Switch Page    ${Current_Page}[0]
            Run Keyword And Continue On Failure    Get Title    validate    value not in ["Page not found", ${None}, ${EMPTY}]
            Run Keyword If    ('fraud-prevention' in '${link}') or ('privacy-polic' in '${link}') or ('accessibility-statement' in '${link}') or ('d.COM' in '${link_text}')    Go Back
        END
    END

Verify Tooltip Style and Disclosure
    [Arguments]    ${locator}
    Run Keyword And Continue On Failure   Verify Tooltip Style    ${locator} >> [data-qa="d-icon-information-expressive"]
    Hover    ${locator} >> [data-qa="d-icon-information-expressive"]
    Run Keyword And Continue On Failure    Wait For Elements State    ${locator} >> ../.. >> [data-qa="d-tooltip-window"]       visible
    Run Keyword And Continue On Failure    Get Text   ${locator} >> ../.. >> [data-qa="d-tooltip-window"]     !=    ${EMPTY}

Check Navigation To Valid Content
    [Arguments]         ${locator}
    [Documentation]     Click on given locator and verify navigation
    ${href}       Run Keyword And Continue On Failure    Get Property        ${locator}         href
    Click       ${locator}
    Run Keyword And Continue On Failure     Wait For Function       () => document.readyState=="complete"
    Run Keyword And Continue On Failure     Get Url    validate    (value == '${href}') or ('${Youtube_Relative_URL}' in value)
    Go Back