
*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${TMP_PATH}                 /tmp
${GOOGLE_SEARCH}            //*[@id="tsf"]/div[2]/div/div[1]/div/div[1]/input
${GOOGLE_SEARCH_BTTN}       //*[@id="tsf"]/div[2]/div/div[3]/center/input[1]

${amit}                      3.14

*** Test Cases ***
Open Google
    Open Chrome Browser
    GoTo    http://google.com
    ${title}=       Get Title
    Should Be Equal    Google    ${title}

*** Keywords ***
Open Chrome Browser
    ${options}  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Log To Console      ${options}     
    Call Method  ${options}  add_argument  --headless
    Call Method  ${options}  add_argument  --privileged
    Call Method  ${options}  add_argument  --no-sandbox
    ${prefs}    Create Dictionary    download.default_directory=${TMP_PATH}
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    ${flag}     Evaluate     robot.__version__
    Log To Console      ${flag}
    Create Webdriver    Chrome    chrome_options=${options}
