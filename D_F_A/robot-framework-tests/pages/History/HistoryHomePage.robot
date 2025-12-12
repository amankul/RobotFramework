
*** Variables ***
${HistoryHomePage_Div_NavButtons}         .bottomNavButtons
${HistoryHomePage_Video_EmbeddedFrame}    \#embeddedVideo

*** Keywords ***

Test History Page
    Run Keyword If      '${browserlib}'!='firefox'     Set To Dictionary        ${browser_opt}       channel=chrome
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${HISTORY_URL}
    Wait For Elements State       ${HistoryHomePage_Div_NavButtons}


Test History Videos
    [Documentation]     This test verified if the video is ready to play instead of actually playing it.
    ...     As per HTML A/V DOM, ready state return 4 = HAVE_ENOUGH_DATA - enough data available to start playing
    New Page     ${HISTORY_URL}/videos
    Wait For Function	    element => element.readyState==4     ${HistoryHomePage_Video_EmbeddedFrame}        timeout=10s
