*** Variables ***

${TradingScreensHomePage_Label_SlideType}                .present >> .slideType
${TradingScreensHomePage_Label_ModuleTitle}              //h2[contains(text(),'World Markets')]
${TradingScreensHomePage_Class_BreakArea_ActiveSlide}    .active


*** Keywords ***

Verify Slide Transition on Break Area
    FOR    ${idx}    IN RANGE    3
        ${classes_before_transition}        Get Classes     ${TradingScreensHomePage_Class_BreakArea_ActiveSlide}
        Run Keyword And Continue On Failure     Wait For Condition      Classes       ${TradingScreensHomePage_Class_BreakArea_ActiveSlide}      validate    value != ${classes_before_transition}     timeout=70
    END
