*** Settings ***
Documentation     Variables and tests that are common to all test cases and suites
Library           OperatingSystem
Library           String
Resource          login.resource  # Contains attributes and other resources necessary for logging in to web site

*** Variables ***
# ************
# Test Objects
# ************

# *********
# Constants
# *********
${BROWSER}                          Headless Chrome
${TMP_PATH}                         /tmp
${system}

# ****************
# Global Variables
# ****************

*** Keywords ***
Open My d Page
    [Arguments]  ${existingSession}=False
    ${system}=    Evaluate    platform.system()    platform
    Set Suite Variable  ${system}
    Open Chrome Browser  ${existingSession}
    Maximize Browser Window
    ## Set Window Size    1920  1080
    Display Test Environment
    Delete All Cookies
    Go To  ${URL}
    Login Page Should Be Open
    #Capture Page Screenshot  login.png

Open Chrome Browser
    [Arguments]  ${existingSession}
    ${options}  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method  ${options}  add_argument  --no-sandbox
    Call Method  ${options}  add_argument  --privileged
    Run keyword if  '${system}' == 'Linux'    Call Method  ${options}  add_argument  --headless
    Call Method  ${options}  add_argument  --window-size\=1920,1080
    ${arg as bool}    Evaluate    robot.utils.is_truthy($existingSession)    modules=robot
    #Log  Existing session is ${arg as bool}  console=yes
    Run Keyword If  ${arg as bool}
    ...  Call Method  ${options}  add_argument  --user-data-dir\=C:/Projects/ChromeSessions
    Call Method  ${options}  add_argument  --start-maximized
    Call Method  ${options}  add_argument  --disable-gpu
    Call Method  ${options}  add_argument  --verbose
    Call Method  ${options}  add_argument  --test-type\=ui
    Call Method  ${options}  add_argument  --disable-infobars
    ${prefs}    Create Dictionary    download.default_directory=${TMP_PATH}
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    Create Webdriver    Chrome    chrome_options=${options}

Display Test Environment
    Log  Test Environment...  console=yes
    ${system}=    Evaluate    platform.system()    platform
    ${version}=    Evaluate    platform.version()    platform
    Log  ${system} ${version}  console=yes
    ${seleniumLibrary}=    Get Library Instance    SeleniumLibrary
    ${capabilities}=    Set Variable    ${seleniumLibrary.driver.capabilities}
    ${browser version}=    Set Variable    ${capabilities['browserVersion']}
    ${browser name}=    Set Variable    ${capabilities['browserName']}
    Log  ${browser name} ${browser version}  console=yes
    ${chromedriver}=  Set Variable  ${capabilities['chrome']['chromedriverVersion']}
    ${chromedriver version}=  Get Regexp Matches  ${chromedriver}  \\d+\.\\d+\.\\d+\.\\d+
    Log  chromedriver ${chromedriver version[0]}  console=yes
    ${SeleniumLibrary version}=  Evaluate  SeleniumLibrary.__version__  SeleniumLibrary
    Log  Selenium Library ${SeleniumLibrary version}  console=yes
    ${robot version}=  Get Robot Framework Version
    Log  ${robot version}  console=yes
    ${IP}  Run keyword if  '${system}' == 'Windows'  Get Windows IP
    ...  ELSE  Get Linux IP
    Log  Running test from IP ${IP}  console=yes

Get Robot Framework Version
    ${RF version}=  Run  robot --version

    [Return]  ${RF version}

Get Windows IP
    ${frt}=     Run     ipconfig | find "IPv4"
    ${IP}=    Fetch From Right    ${frt}    ${SPACE}

    [Return]  ${IP}

Get Linux IP
    ${IP}=  Run  hostname -I

    [Return]  ${IP}

Close Browser
    Close All Browsers

Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})

Refresh Web Page
    Reload Page

Default Test Teardown
    Run Keyword If Test Failed    Capture Page Screenshot
