##This is page object of us-en/insights/managing-your-practice page

*** Variables ***
${AudioComponent_Div_Title}                    [data-qa="audio-title"]
${AudioComponent_Div_Description}              [data-qa="audio-description"]
${AudioComponent_Image_Thumbnail}              [data-qa="audio-image"]
${AudioComponent_Player_CurrentTime}           span.vjs-current-time-display
${AudioComponent_Button_PlayControl}           button.vjs-play-control

*** Keywords ***
Verify Title, Description and Image
    Run Keyword And Continue On Failure     Get Text    ${AudioComponent_Div_Title}    !=    ${EMPTY}
    Run Keyword And Continue On Failure     Get Style    ${AudioComponent_Div_Title}    color     ==    ${AlmostBlack}
    Run Keyword And Continue On Failure     Get Text    ${AudioComponent_Div_Description}    !=    ${EMPTY}
    Run Keyword And Continue On Failure     Get Property    ${AudioComponent_Image_Thumbnail}    src        validate    any(v in value for v in @{Image_Extensions})

Check Audio Playback
    ${startTime}     Run Keyword And Continue On Failure    Get Text    ${AudioComponent_Player_CurrentTime}
    Run Keyword And Continue On Failure    Get Property    ${AudioComponent_Button_PlayControl}     title    ==    Play
    Click        ${AudioComponent_Button_PlayControl}
    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    5x    2 sec    Wait For Condition      text    ${AudioComponent_Player_CurrentTime}    !=    ${startTime}
    Click    ${AudioComponent_Button_PlayControl}
    Run Keyword And Continue On Failure    Get Classes    ${AudioComponent_Button_PlayControl}    contains    vjs-paused