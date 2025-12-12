*** Settings ***
Resource       ../../env/${environment}.resource
Resource       ../../pages/GlobalKeywords.robot
Resource       ../../pages/GlobalVariables.robot
Resource       ../../pages/PublicSite/AudioComponent.robot
Resource       ../../pages/PublicSite/ExhibitComponentPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/d360/EventsSchedulePage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/d360/InvestmentResources.robot
Resource       ../../pages/PublicSite/FinancialProfessional/d360/Overview.robot
Resource       ../../pages/PublicSite/FinancialProfessional/dInvesting/AllFundsPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/dInvesting/dDifferencePage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/dInvesting/OurApproachPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/HomePage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/SiteCoreFormsPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/WhoWeAre/AboutUsPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/WhoWeAre/BioPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/WhoWeAre/CareersPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/WhoWeAre/NewsroomPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/WorkWithUs/InstitutionsPage.robot
Resource       ../../pages/PublicSite/FinancialProfessional/WorkWithUs/Institutions_JohnHancockIndexesPage.robot
Resource       ../../pages/PublicSite/IndividualInvestor/FoundationsOfInvestingPage.robot
Resource       ../../pages/PublicSite/IndividualInvestor/HomePage.robot
Resource       ../../pages/PublicSite/IndividualInvestor/HowToInvestPage.robot
Resource       ../../pages/PublicSite/OurHeritage.robot
Resource       ../../pages/PublicSite/RemembranceModalPage.robot
Resource       ../../pages/PublicSite/SearchPage.robot
Resource       ../../pages/PublicSite/SplashPage.robot
Resource       ../../pages/PublicSite/InsightsPage.robot
Suite Setup    Run Keywords    Get-Credentials
Test Setup     Initialize Browser
Test Timeout       15 minutes

*** Test Cases ***

Check All Funds Page
    [Tags]    SERVERSAT    REGRESSION    DAILYRUN
    [Documentation]  This test confirms funds page can be naviageted and opened.
    Set To Dictionary    ${browser_opt}    args=["--disable-web-security"]
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${PUBLIC_SITE_URL}/us-en/funds
    Select Audience         professional

    Check Portfolio Name & NAVs


Check Public Site Random Fund Documents
    [Tags]             SERVERSAT    REGRESSION
    [Documentation]    This test confirms all funds documents can be opened.
    ...                NOTE: Random document links are being validated in this test. No titles are validated.
    Set To Dictionary    ${browser_opt}    args=["--disable-web-security"]
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${PUBLIC_SITE_URL}/us-en/funds
    Select Audience         professional

    Verify Fund Documents Load


Verify Hancock Index Page
    [Tags]    SERVERSAT     REGRESSION        DAILYRUN
    [Documentation]  This test confirms hancock index page contains index methodology documents by downloading one
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${PUBLIC_SITE_URL}/john-hancock-indexes
    Select Audience         professional

    Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
    Evaluate Random Document


Verify Careers Page
    [Tags]             REGRESSION        DAILYRUN
    [Documentation]    This test verifies career page renders and content works fine.
    [Timeout]            2 minutes
    Log    Opening ${CAREERS_URL}    console=True
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${CAREERS_URL}

    Run Keyword And Continue On Failure    Navigate To Active Openings    ${CareersPage_Option_Internships}
    Navigate To Active Openings    ${CareersPage_Option_Professionals}


Check Newsroom Media Contacts
    [Tags]           REGRESSION
    [Documentation]  Verify that the media contacts banner is displayed for a given country.
    ...              It was decided in https://jira.d.com/browse/DDXP-5945 to only test using country as 'US' for now.
    ...              In future we can validate for other countries such as 'AU', 'CA', 'CH', 'DE', 'HK', 'IE', 'NL', 'SG', 'UK'.
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/newsroom
    Select Audience    professional

    Check Media Contacts


Verify Bio page
    [Tags]           REGRESSION           DAILYRUN
    [Documentation]  Verify the bio page for David Booth renders and has all required parts like title, quote, right rail etc.

    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/bios/david-booth
    Select Audience    individual

    Run Keyword And Continue On Failure        Verify English Bio Page
    Go To   ${PUBLIC_SITE_URL}/de-de/bios/david-booth
    Verify German Bio Page


Verify People Container and People Card

    [Tags]           REGRESSION           DAILYRUN
    [Documentation]  Verify the people container title and description, in-page tabs and people cards on the about us page

    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${AboutUs_CMSPage_PathUS}
    Select Audience        professional

    Run Keyword And Continue On Failure        Verify Title and Description
    Run Keyword And Continue On Failure        Verify In-page Tab
    Verify People Card Details


Check Video Header With Static Text
    [Tags]           REGRESSION           DAILYRUN
    [Documentation]  Verify the video header with static text component for background video, title, subtitle, accent bar,
    ...              poster image and mobile background image.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/who-we-are/about-us
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${AboutUs_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Verify Header Background Video
    Run Keyword And Continue On Failure    Verify Header Title, Subtitle and Accent Bar
    Verify Mobile Background Image And Poster Image


Verify SRRI Flag for NL users
    # Skipping the execution of this test as advised by MK.
    # Intentionally not deleting it considering this SRRI process can come back again in future.
    Skip
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Test just verifies users who access our Netherlands (NL) country and downloads a digital version of a page which has been tagged
    ...                to require a SRRI document, the SRRI document will be included in a Zip file along with any PDF that is generated
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/nl-nl/document-center
    FOR     ${doc_type}    IN       @{SRRI_Doc_Types}
            ${all_documents}        Get Elements        "${doc_type}"
            ${document}     Evaluate  random.choice($all_documents)
            ${file_obj}     Download Given Document            ${document}
            Run Keyword And Continue On Failure    Should Contain    ${file_obj.suggestedFilename}    .zip     ignore_case=True
            # zips see were more than 800 KB hence check size against arbitrary threshold of 350 KB
            ${zip_size}        Get File Size        ${file_obj.saveAs}
            Run Keyword And Continue On Failure    Should Be True 	    ${zip_size} > 350000
    END


Verify Fast Facts
    [Tags]           REGRESSION    DAILYRUN
    [Documentation]  Verify the fast facts component for title, subtitle and datapoint details.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/who-we-are/about-us
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${AboutUs_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Check FastFacts Title and Subtitle
    Run Keyword And Continue On Failure    Check English Datapoints Count
    Run Keyword And Continue On Failure    Check Datapoints Title and Description
    Check German Datapoints Count


Verify Springboard Cards
    [Tags]           REGRESSION           DAILYRUN
    [Documentation]  Verify springboard cards inside springboard container. Note production runs on live about us page.
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/who-we-are/about-us
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${AboutUs_CMSPage_PathUS}
    END
    Select Audience    professional

    Verify Springboard Eyebrow, Headline,GA and CTA


Verify One Column Center Container and One Column Text
    [Tags]           REGRESSION    DAILYRUN
    [Documentation]  Verify the one column text accent bar, eyebrow, title and description.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/who-we-are/about-us
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${AboutUs_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Verify One Column Center Container
    Verify One Column Text Accent Bar, Eyebrow, Title and Description


Verify Full Width Video With Card
    [Tags]           REGRESSION    DAILYRUN
    [Documentation]  Verify the full width video with card component for video details, card title,
    ...              card description and video duration on card.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/who-we-are/about-us
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${AboutUs_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Verify Full Width Video
    Verify Full Width Video Card Title, Description and Video-duration


Verify Content Card Carousel
    [Tags]           REGRESSION        DAILYRUN
    [Documentation]  Verify cards(featured and content) within carousel container. Also verifies hover, carousel scroll and CTA.

    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${ProHome_CMSPage_Path}
    END

    #Run Keyword And Ignore Error    Click    ${RemembranceModalPage_Button_Close}
    Run Keyword And Continue On Failure    Verify Featured Content Card
    Run Keyword And Continue On Failure    Verify Content Card
    Run Keyword And Continue On Failure    Verify Hover Effect
    Run Keyword And Continue On Failure    Verify Scroll
    Verify Carousel Container Header and CTA


Verify Springboard Plus Cards
    [Tags]           REGRESSION        DAILYRUN
    [Documentation]  Verify springboard cards within utility container. Also verifies hover and CTA.

    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${ProHome_CMSPage_Path}
    END

    #Run Keyword And Ignore Error    Click    ${RemembranceModalPage_Button_Close}
    Run Keyword And Continue On Failure    Verify Title and Description Utility Container
    Test Springboard Plus Card


Verify Video Header With Animated Text
    [Tags]           REGRESSION    DAILYRUN
    [Documentation]  Verify the video header with animated text component for background video, title static line,
    ...              title animated lines, accent bar, mobile background image and poster image.

    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${ProHome_CMSPage_Path}
    END

    Run Keyword And Continue On Failure    Verify ProHome Header Background Video
    Run Keyword And Continue On Failure    Verify ProHome Header Title Static Line, Animated Lines and Accent Bar
    Verify ProHome Header Mobile Background Image And Poster Image


Verify d Difference Header Banner
    [Tags]           REGRESSION    DAILYRUN
    [Documentation]  Verify the d difference header banner component for background video, eyebrow,
    ...              animated lines, mobile background image and poster image.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Verify DDiff Header Banner Video
    Run Keyword And Continue On Failure    Verify DDiff Eyebrow And Animated Lines
    Verify DDiff Mobile Background Image And Poster Image


Verify Centered Fast Facts
    [Tags]           REGRESSION    DAILYRUN
    [Documentation]  Verify the d difference centered fast facts component for
    ...              datapoint icon, description and subdescription.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Check DDiff English Datapoints Count
    Run Keyword And Continue On Failure    Check DDiff Datapoints Icon, Description and Subdescription
    Check DDiff German Datapoints Count


Verify Animated Paragraph
    [Tags]           REGRESSION    DAILYRUN
    [Documentation]  Verify the d difference animated paragraph text presence.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Check Animated Paragraph Text


Verify Animated Donut
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the animated donut on d difference page and its properties like title, description, %
    ...                with hover and disclosure overrides.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Check Animated Donut Title, Description and Percentages
    Verify Disclosure and Tooltip


Verify Animated Section Header
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the d difference animated section header text and vertical line.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Check Animated Section Header Text
    Check Animated Section Header Border


Verify Research In Our DNA within Split Animated Content Block
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the research in our dna component within split animated content block for
    ...                title, card colors, card background colors, card title and card description.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Check Split Animated Content Block
    Check Research In Our DNA


Verify Standalone Littlei
    [Tags]             REGRESSION
    [Documentation]    Verify the standalone tooltip works for hover and style changes. Also verify disclosure text.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional
    Run Keyword And Continue On Failure    Verify Hover and Style for Tooltip
    Verify Tooltip Disclosure Text


Verify Laureates Exhibit
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the laureates exhibit for title and placard details like laureate's image, name, award, date
    ...                and description. Also validate the states for meatball and the bottom container hide/show on toggle.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Check Laureates Exhibit Title and Placard Details
    Check Laureates Exhibit Meatball Toggle and Description


Verify Outperformed Animated Exhibit
    [Tags]             REGRESSION        DAILYRUN
    [Documentation]    Verify the headline, stock titles, outperformed %, survived %, disclosure. Also verify styling of bar graphs.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional
    Run Keyword And Continue On Failure    Verify Infographic Headline, Tooltip and Disclosure
    Verify Outperformed Charts


Verify Premiums Exhibit
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the premiums exhibit for infographic headline and title. Check the toggle switch states, the chart text and images.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Check Premiums Infographic Headline And Title
    Run Keyword And Continue On Failure    Check Premiums Toggle Switch
    Run Keyword And Continue On Failure    Check Premiums Cards
    Run Keyword And Continue On Failure    Click    ${dDifferencePage_Checkbox_PremiumsToggle}
    Check Premiums Cards


Verify Quote Block
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the quote block for its quote symbol, text, name and title.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Check Quote Symbol, Text, Name and Title


Verify Best Of Both Exhibit
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the best of both lotties title. Also verify title, subcopy and achievements for all the 3 sections at mobile breakpoint.
    Set To Dictionary        ${context_opt}       viewport={'width': 360, 'height': 720}
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional
    Verify Title and 3 Sections of Lottie


Verify Micro Cap Animated Exhibit
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the infographic headline,  title, growth and disclosure. Also check chart circle and compare start value, end value, annulized returns etc
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${dDifference_Page_Path}
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${dDifference_CMSPage_PathUS}
    END
    Select Audience    professional

    Run Keyword And Continue On Failure    Verify Infographic Headline, Chart Title with Growth & Disclosure
    Verify Microcap Chart Circle and Graph


Verify Full Width Image With Card
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the full width image, its card title and card description.
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals/d-360
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${d360_CMSPage_Path}
    END

    Verify Full Width Image And Card


Verify Information Cards
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify title and card description for information cards.
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals/d-360
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${d360_CMSPage_Path}
    END
    Run Keyword And Continue On Failure   Verify All Information Cards
    Verify CTA Area


Verify Utility Cards
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify utility container theme, accent bar and font style.
    ...                Verify utility cards title, description and meatball.
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals/d-360
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${d360_CMSPage_Path}
    END
    Run Keyword And Continue On Failure    Verify Utility Container Accent Bar and Theme
    Verify Utility Cards Title, Description and Meatball


Verify Featured Textbox
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify featured text box accent bar, eyebrow, headline and description.
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals/d-360
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${d360_CMSPage_Path}
    END

    Run Keyword And Continue On Failure    Run Keyword If  '${environment}' != 'production'    Verify Featured Text Box Accent Bar, Eyebrow and Headline
    Verify Featured Text Box Description

Verify One-To-One Column Image
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify one to one column image exists within right module of one to one column container
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals/d-360/investment-resources
    Verify One-To-One Column Container & Image


Verify Popup Video
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify that the popup video opens in an iframe. Check that it plays and has specific controls visible.
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    Run Keyword If    '${browser}' != 'firefox'     Set To Dictionary    ${browser_opt}       channel=chrome
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals/d-360
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${d360_CMSPage_Path}
    END

    Run Keyword And Continue On Failure    Verify Video Plays    popup
    Run Keyword And Continue On Failure    Verify Video Controls
    Verify Popup Video iFrame


Verify Inline Video
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify that the inline video plays and has specific controls visible.
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    Run Keyword If    '${browser}' != 'firefox'     Set To Dictionary    ${browser_opt}       channel=chrome
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${d360_CMSPage_Path}

    Run Keyword And Continue On Failure    Verify Video Plays    inline
    Verify Video Controls


Verify Horizontal Divider and Spacer2.0
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify horizontal divider height, color and class name.
    ...                Verify spacer height and class name.
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/financial-professionals/d-360
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${d360_CMSPage_Path}
    END

    Run Keyword And Continue On Failure    Check Divider Height, Color and Class
    Check Spacer Height and Class


Verify Image Card Carousel
    [Tags]           REGRESSION        DAILYRUN
    [Documentation]  Verify image cards within image card carousel container. Verify hover, carousel scroll and CTA for image cards.
    ...    Verify image card carousel container accent bar, eyebrow, description, headline and meatball.

    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/individual
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${IndHome_CMSPage_Path}
    END

    #Run Keyword And Ignore Error    Click    ${RemembranceModalPage_Button_Close}
    Run Keyword And Continue On Failure    Verify Image Card Title, Description and Image
    Run Keyword And Continue On Failure    Verify Image Card Hover
    Run Keyword And Continue On Failure    Verify Image Card GA Attributes
    Run Keyword And Continue On Failure    Verify Image Card Carousel Scroll and Navigation
    Verify Image Card Carousel Container


Verify Animated Markets
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify title, subcopy, images and description for cards in animated markets.

    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/individual
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${IndHome_CMSPage_Path}
        Select Audience    individual
    END

    Run Keyword And Continue On Failure    Check Cards Header
    Check Cards Footer


Verify Flex Header
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify eyebrow, title, subtitle, accent bar, description and image for flex header.

    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/individual/how-to-invest
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${IndHome_CMSPage_Path}/how-to-invest
    END

    Run Keyword And Continue On Failure    Check Flex Header Eyebrow, Title and Subtitle
    Run Keyword And Continue On Failure    Check Flex Header Accent Bar and Description
    Check Flex Header Image

Verify Animated Fast Facts
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify title and description of data points within animated fast facts container along with animation checks
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/individual
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${IndHome_CMSPage_Path}
    END

    Check Animated Fast Facts Datapoints


Verify Anchor Link Row
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the anchor link row attributes. Verify that both the scroll positions match by first clicking the anchor link
    ...                and getting the scroll position and then using the browser scroll functionality to reach the same element and
    ...                getting the scroll position.

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/individual/how-to-invest
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${IndHome_CMSPage_Path}/how-to-invest
    END

    Run Keyword And Continue On Failure    Check Anchor Link Icon, Text and GA Attributes
    Check Anchor Link Scroll


Verify Billboard Container
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify billboard container background color and mobile row order attributes.

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/individual/foundations-of-investing
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${IndHome_CMSPage_Path}/foundations-of-investing
    END

    Verify Billboard Container Attributes

Verify Standalone Links in Content Block Container
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify content block container title, content and background colors.

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/individual/foundations-of-investing/you-may-know-more-about-investing-than-you-think
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${IndHome_CMSPage_Path}/foundations-of-investing
    END

    Check Content Block Container


Verify Strategies Graphic
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify strategies graphic title, description, sub-description and background highlight.
    ...                Additionally verify subgroup title and hover.

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${Institutions_CMSPage_Path}

    Run Keyword And Continue On Failure    Check Strategies Graphic Title, Description and Sub-description
    Run Keyword And Continue On Failure    Check Strategies Graphic Background Color
    Check Strategies Graphic Subgroup Title and Hover


Verify Standalone Meatball
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify standalone meatball hover styling, navigation and GA attributes.
    ...                NOTE: The GA attribute is being used to locate the CTA, hence it is automatically validated.

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${Institutions_CMSPage_Path}

    Check Meatball Hover, Navigation and GA Attributes


Verify Image Header With Static Text
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify image header with static text for eyebrow, title, accent bar, theme and image.

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${Institutions_CMSPage_Path}

    Run Keyword And Continue On Failure    Check Static Text Image Header Eyebrow, Title and Accent Bar
    Check Static Text Image Header Theme and Background Image


Verify Remembrance Modal Portrait
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the portrait remembrance modal for its container, image, name,
    ...                lifespan, eyebrow, title, description, cta link, ga attributes and close button.

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${RemembranceModalPortrait_CMSPage_Path}
    Run Keyword And Continue On Failure    Check Remembrance Modal Container, Image, Background Image, Name and Lifespan
    Run Keyword And Continue On Failure    Check Remembrance Modal Eyebrow, Title and Description
    Check Remembrance Modal CTA, GA Attributes and Close Button


Verify Remembrance Modal Silhouette
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the silhouette remembrance modal for its container, image, name,
    ...                lifespan, eyebrow, title, description, cta link, ga attributes and close button.

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${RemembranceModalSilhouette_CMSPage_Path}
    Run Keyword And Continue On Failure    Check Remembrance Modal Container, Image, Background Image, Name and Lifespan
    Run Keyword And Continue On Failure    Check Remembrance Modal Eyebrow, Title and Description
    Check Remembrance Modal CTA, GA Attributes and Close Button


Verify Public Site Search
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify search bar and do various searches(blank, obsure, regular). Also verify search results sorting, card types and validity
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}
    Select Audience    individual
    #Run Keyword And Ignore Error    Click    ${RemembranceModalPage_Button_Close}
    Run Keyword And Continue On Failure    Verify Search Bar
    Run Keyword And Continue On Failure    Blank Search and Obscure Search
    Run Keyword And Continue On Failure    Validate Search Results Page
    Run Keyword And Continue On Failure    Search Various Card Types
    Run Keyword And Continue On Failure    Ensure Only Audience Specific Results Showup
    Search For Non-US Countries Is Hidden


Verify Form Submissions
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Check three different sitecore forms and their submissions using the test phrase.
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en
    Select Audience    professional
    Run Keyword And Continue On Failure    Verify Contact Us Form
    Run Keyword And Continue On Failure    Verify Request A Demo Form
    Verify California Consumer Privacy Act Form


Verify Inline Exhibit and Scroll Exhibit
    [Tags]    REGRESSION    DAILYRUN
    [Documentation]    Verify the inline exhibit title, subtitle, description, image, border, disclosure, tooltip and popup modal.
    ...                Verify the scroll exhibit title, slide text, slide image, scroll behavior and little i tooltip.
    Set To Dictionary    ${browser_opt}    args=["--start-maximized"]
    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic    viewport=${None}
    New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${PUBLIC_SITE_CMS_URL}/${ExhibitComponent_CMSPage_Path}
    Run Keyword And Continue On Failure    Verify Inline Exhibit
    Verify Scroll Exhibit


Verify Access and Use
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify only public login pages are accessible. Also individuals can't open pages marked for professional use.
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${RemembranceModalSilhouette_CMSPage_Path}
    Select Audience    individual
    Run Keyword And Continue On Failure    Wait For Function       () => dataLayer[0]["title"]=="Remembrance Page - Silhouette"
    Run Keyword And Continue On Failure    Go To    ${PUBLIC_SITE_CMS_URL}/${ExhibitComponent_CMSPage_Path}
    Run Keyword And Continue On Failure     Affirm For Professionals
    Run Keyword And Continue On Failure    Wait For Function       () => dataLayer[0]["title"]=="Exhibit Component Page"
    Run Keyword And Continue On Failure    Go To    ${PUBLIC_SITE_CMS_URL}/${ClientLoginClientReady_CMSPage_Path}
    Wait For Function       () => dataLayer[0]["title"]=="Page Not Found"


Verify Audio Component
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify title, desc, thumbnail and audio playback for audio component.
    Run Keyword If    '${browser}' != 'firefox'     Set To Dictionary    ${browser_opt}       channel=chrome
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${AudioComponent_Page_Path}
    Select Audience    individual
    Run Keyword And Continue On Failure    Verify Title, Description and Image
    Check Audio Playback


Verify Image Component
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify title, description, image, mobile image, image link and module borders.
    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${d360_CMSPage_Path}
    Run Keyword And Continue On Failure    Verify Image Component Title, Description and Borders
    Run Keyword And Continue On Failure    Verify Image Component Image
    Verify Image Component Tooltip


Verify Geo IP Service
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify that the geo ip service detects the ip correctly and prompts the correct splash page accordingly.
    ${header_opt}    Create Dictionary    CF-IPCountry=IS
    Set To Dictionary    ${context_opt}    extraHTTPHeaders=${header_opt}
    Run Keyword And Continue On Failure    Check Splash Page States    attached    detached
    Run Keyword And Continue On Failure    Close Browser
    Set To Dictionary    ${header_opt}    CF-IPCountry=DE
    Set To Dictionary    ${context_opt}    extraHTTPHeaders=${header_opt}
    Run Keyword And Continue On Failure    Check Splash Page States    detached    attached
    Run Keyword And Continue On Failure    Get Property    ${SplashPage_Text_GlobalSplashCountry}    textContent    equals    Deutschland
    Run Keyword And Continue On Failure    Close Browser
    Remove From Dictionary    ${context_opt}    extraHTTPHeaders
    Run Keyword And Continue On Failure    Check Splash Page States    detached    attached
    Get Property    ${SplashPage_Text_GlobalSplashCountry}    textContent    equals    United States


Verify Animated Donut Graph 3
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verified donut3 disclosures, title, desc, percentages, littlei and teal styling
    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/our-approach
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${OurApproach_CMSPage_PathUS}
    END
    Run Keyword And Continue On Failure    Check Animated Donut Title, Description and Percentages Donut3
    Verify Disclosure and Tooltip Donut3


Verify Column Cards
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the column card container label and arrow.
    ...                Verify column card title, description, image, cta and GA attributes.
    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic    viewport={'width': 1440, 'height': 800}
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/our-approach
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${OurApproach_CMSPage_PathUS}
    END

    Check Column Cards

Verify Extended Card Carousel
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the extended card carousel container title, background image, toggle for viewall/collapse.
    ...                Also verify scroll and individual cards(title, desc, littlei)

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/our-approach
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${OurApproach_CMSPage_PathUS}
    END
    Run Keyword And Continue On Failure    Verify Title and Background Image For Extended Card
    Run Keyword And Continue On Failure    Verify Toggle and Scroll
    Verify Individual Extended Cards


Verify Events Schedule
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the events schedule table for table title, brochure download link,
    ...                event details (event date, name, location, info and CE), no events message and all GA attributes.

    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${EventsSchedule_Page_Path}

    Run Keyword And Continue On Failure    Check Events Table Title, No Event Message and Download Brochure Link
    Run Keyword And Continue On Failure    Check Events Table Grid Values
    Check Events Table Pagination


Verify Our Heritage Timeline
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify the our heritage page timeline for its cover card fields, individual year card fields, disclosures and
    ...                mobile breakpoint behavior.

    Set To Dictionary    ${browser_opt}    args=["--start-maximized"]    headless=False
    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic    viewport=${None}
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/our-heritage
    Wait For Load State    networkidle

    Run Keyword And Continue On Failure    Check Timeline Using Scroll And Clicks
    Run Keyword And Continue On Failure    Check Timeline Cover Card
    Run Keyword And Continue On Failure    Check Timeline Year Cards
    Run Keyword And Continue On Failure    Check Timeline Disclosures
    Check Timeline On Mobile

Verify Insights Featured Content
    [Tags]             REGRESSION    DAILYRUN
    [Documentation]    Verify featured content on insights page for image/video, navigation, ga attributes etc
    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    Run Keyword If    '${browser}' != 'firefox'     Set To Dictionary    ${browser_opt}       channel=chrome
    IF  '${environment}' == 'production'
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/insights
    ELSE
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_CMS_URL}/${Insights_CMSPage_Path}
    END

    Run Keyword And Continue On Failure    Verify Main Image or Video
    Verify Article Area


Verify Splash Page Workflows
    [Tags]        REGRESSION    DAILYRUN
    [Documentation]  This test confirms different splash page workflows(global, audience selector, affirmation etc) are functioning as expected.
    Run Keyword And Continue On Failure    Verify Audience Preference on Global Splash    individual    /au-en/individual
    Run Keyword And Continue On Failure    Verify Audience Preference on Global Splash    professional    /us-en/financial-professionals
    Run Keyword And Continue On Failure    Verify Blurred Individual Page With Shared URL
    Run Keyword And Continue On Failure    Verify Affirmation For Professional Only URL
    Run Keyword And Continue On Failure    Verify Mismatch Banner
    Run Keyword And Continue On Failure    Verify Unapproved Country Professional Page