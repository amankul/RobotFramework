*** Settings ***
Documentation     A test suite containing tests related to login functionality.
Metadata          Version       0.1
Metadata          Test Case     AAI-T231
Metadata          Test Case     AAI-T684
Default Tags      CARPO     Smoke    Regression
Suite Setup       Open My d Page
Suite Teardown    Close Browser
Test Setup
Test Teardown
Library           SeleniumLibrary    timeout=10    implicit_wait=3    run_on_failure=None
Library           RequestsLibrary
Library           ExtendedRequestsLibrary
Library           json
Resource          d.resource      # Generic objects, and keywords for all pages
Resource          Myd.resource    # Contains xpath, attributes and other resource links to artifacts on the My d page.
Resource          login.resource            # Contains xpath, attributes and other resources necessary for logging in to web site
Resource          browser.resource          # Contains attributes and other resources necessary for manipulating the browser

*** Variables ***
${URL_DD_HOST}    https://data-stage.d.com
${URL_CLIENT}     https://www-uat.myd.com
${URL_OKTA}       https://d-stage.oktapreview.com

*** Test Cases ***
Test DD API
    Log In As External Client  ${VALID_USER}  ${VALID_PASSWORD}
    Click Button  ${NAV_FUNDS}
    Sleep  20s
    Go To  https://data-stage.d.com
    Sleep  2s
    ${cookies}=  Get Cookies  as_dict=True
    Log  Page Cookies are ${cookies}  console=yes
    RequestsLibrary.Create Session    ddapp    ${URL_DD_HOST}  cookies=${cookies}
    ${resp}=  RequestsLibrary.Get Request  ddapp  /ddx_models/v0/fundcenter
    Log  ${resp.status_code}  console=yes
    Log  ${resp.text}  console=yes

*** Keywords ***
Create DD App Session
    # Log into Client site first!!
    ${req_dict}  Create Dictionary  username=${VALID_USER}  password=${VALID_PASSWORD}
    ${payload}=  Json.Dumps  ${req_dict}
    ${resp}=  RequestsLibrary.Post Request  ddx  /user-api/login  data=${payload}  allow_redirects=True
    Log  External User ${VALID_USER} Login Status: ${resp.status_code}  console=yes

    Should Be Equal As Strings  ${resp.status_code}  ${200}
    ${matches}=  Get Regexp Matches  ${resp.text}  &state=([a-zA-Z0-9_-]+)  1
    ${state}=  Set Variable  ${matches[0]}
    ${matches}=  Get Regexp Matches  ${resp.text}  &sessionToken=([a-zA-Z0-9_-]+)  1
    ${session_token}=  Set Variable  ${matches[0]}

    ${okta_url}=  Catenate  SEPARATOR=  /oauth2/aush21l1u0mG50qMp0h7/v1/authorize?scope\=openid+profile+offline_access+ClientSiteScope+crmapi\%3Aarmory\&sessionToken\=  ${session_token}  \&response_type\=code\&redirect_uri\=  ${URL_CLIENT}  /oauth2/callback&state\=  ${state}  \&prompt\=none\&client_id\=0oah1xd6seOmY6pT80h7
    ${resp}=  RequestsLibrary.Get Request  okta    ${okta_url}  allow_redirects=True
    LOG  ${resp.history}  console=yes
    Log  DDX OAuth2 Status Code: ${resp.status_code}  console=yes
    Should Be Equal As Strings  ${resp.status_code}  ${200}
    Log  Okta External User Login Completed!!  console=yes

    Log  Starting Data Distribution Authentication ...  console=yes

    ${resp}=  RequestsLibrary.Get Request  ddx  /tools/apps
    Should Be Equal As Strings  ${resp.status_code}  ${200}
    Log  Loaded Data Tools Page  console=yes

    ${resp}=  RequestsLibrary.Get Request  okta    /api/v1/sessions/me
    Log  sessions/me status code: ${resp.status_code}  console=yes
    Should Be Equal As Strings  ${resp.status_code}  ${200}

    ${resp}=  RequestsLibrary.Get Request  ddapp  /ddx_models/oauth2/session
    Should Be Equal As Strings  ${resp.status_code}  ${401}
    Log  DD APP OAuth2 Authorization Check Status Code: ${resp.status_code}  console=yes
    ${matches}=  Get Regexp Matches  ${resp.text}  &state=([a-zA-Z0-9_-]+)  1
    ${state}=  Set Variable  ${matches[0]}
    ${matches}=  Get Regexp Matches  ${resp.text}  &client_id=([a-zA-Z0-9_-]+)  1
    ${client_id}=  Set Variable  ${matches[0]}

    ${resp}=  RequestsLibrary.Get Request  okta    /api/v1/sessions/me
    Log  sessions/me status code: ${resp.status_code}  console=yes
    Should Be Equal As Strings  ${resp.status_code}  ${200}

    ${url}=  Catenate  SEPARATOR=  ?response_type\=code\&client_id\=  ${client_id}  \&redirect_uri\=https\%3A\%2F\%2Fdata-stage.d.com\%2Fddx_models\%2Foauth2\%2Fcallback\&state\=  ${state}  \&prompt\=none\&scope=openid+profile+app\%3Addxtools
    #${url}=  Catenate  SEPARATOR=  /oauth2/aush21l1u0mG50qMp0h7/v1/authorize?response_type\=code\&client_id\=  ${client_id}  \&redirect_uri\=  ${URL_DD_HOST}  /ddx_models/oauth2/callback\&state\=  ${state}  \&prompt\=none\&scope\=openid+profile+app\%3Addxtools
    #Log  ${url}  console=yes
    ${resp}=  RequestsLibrary.Get Request  okta  ${url}  allow_redirects=True
    LOG  ${resp.history}  console=yes
    Log  DD App OAuth2 Status Code: ${resp.status_code}  console=yes
    Should Be Equal As Strings  ${resp.status_code}  ${200}

    ${resp}=  RequestsLibrary.Get Request  okta    /api/v1/sessions/me
    Log  sessions/me status code: ${resp.status_code}  console=yes
    Should Be Equal As Strings  ${resp.status_code}  ${200}

    ${resp}=  RequestsLibrary.Get Request  ddapp  /ddx_models/oauth2/session
    Log  ${resp.text}  console=yes
    Should Be Equal As Strings  ${resp.status_code}  ${200}
    Log  Successfully Authenticated DD App!  console=yes

*** Keywords ***
Create API Session
    ${headers_str}=    Evaluate   str('application/json')
    &{headers}=    Create Dictionary    Content-Type=${headers_str}
    RequestsLibrary.Create Session    ddapp    ${URL_DD_HOST}
    RequestsLibrary.Create Session    okta     ${URL_OKTA}
    RequestsLibrary.Create Session    ddx      ${URL_CLIENT}     headers=${headers}