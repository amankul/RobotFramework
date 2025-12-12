## This is for David Booth BioPage page on new public site


*** Variables ***
${BioPage_Image_BoothHeadshot}            .bio-image>img
${BioPage_Text_BioPageName}               .bio-body-name>h1
${BioPage_Text_BioPageQuote}              .bio-body-quote
${BioPage_List_RailAwards&Recognition}    .bio-rail-awards>.list>ul>li
${BioPage_List_RailBoards&Committees}     .bio-rail-boards>.list>ul>li
${BioPage_Text_BioPageTitle}              .bio-body-title
${BioPage_Text_BioPagegraphy}             .t-body-md
${EN-BioPageName}                         David Booth
${DE-BioPageTitle}                        GRÜNDER

*** Keywords ***
Verify English Bio Page
    Get Attribute       ${BioPage_Image_BoothHeadshot}        src    !=    ${EMPTY}
    Get Text        ${BioPage_Text_BioPageName}         ==     ${EN-BioPageName}
    Wait For Elements State        ${BioPage_Text_BioPageQuote}
    Get Element Count        ${BioPage_List_RailAwards&Recognition}      !=     0

Verify German Bio Page
    Get Text        ${BioPage_Text_BioPageTitle}          *=     ${DE-BioPageTitle}
    Wait For Elements State        ${BioPage_Text_BioPagegraphy}
    Get Element Count        ${BioPage_List_RailBoards&Committees}      !=     0