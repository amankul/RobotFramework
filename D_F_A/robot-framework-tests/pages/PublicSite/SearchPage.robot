*** Variables ***
${SearchPage_Button_SearchIcon}               [data-qa="d-primary-nav-icon-button"]
${SearchPage_Input_SearchBox}                 [data-qa="public-search-input"]
${SearchPage_Button_ClearSearch}              [data-qa="public-search-close-button"]
${SearchPage_Div_SearchBoxContainer}          [data-qa="public-search-searchbox-container"]
${SearchPage_Div_NoResults}                   [data-qa="public-search-no-results-try-different-term"]
${SearchPage_List_SearchSuggestions}          [data-qa="public-search-suggestions-list"]
${SearchPage_Div_SearchResultsHeader#}        [data-qa="public-search-number-of-results"]
${SearchPage_Div_SearchResultsHeaderTerm}     [data-qa="public-search-query-text"]
${SearchPage_Button_MoreResults}              [data-qa="public-search-results-show-more-button"]
${SearchPage_Button_SearchResultCards}        [data-qa="public-search-result-card"]
${SearchPage_Dropdown_SortSelection}          [data-qa="public-search-results-sort-by"]
${SearchPage_Div_FirstCard}                   ${SearchPage_Button_SearchResultCards}:first-child
${SingleChar_SearchTerm}                     a
${Obscure_SearchTerm}                        "sdkfhgl2nj;df'lk/nhgfo4LJ@~$po"
${Regular_SearchTerm}                        Etfs
&{SearchType_Terms}                          bios=Karen Dolan    fundname=DFAC    insights=Fed    image=Foundations of Investing    title=About Us

*** Keywords ***

Verify Search Bar
    [Documentation]    Verify Search Bar Opens and closes on scroll. Also search term can be entered and cleared.
    Click    ${SearchPage_Button_SearchIcon}
    Run Keyword And Continue On Failure    Wait For Elements State     ${SearchPage_Div_SearchBoxContainer}    visible
    Type Text    ${SearchPage_Input_SearchBox}     ${SingleChar_SearchTerm}
    Run Keyword And Continue On Failure    Wait For Elements State    ${SearchPage_List_SearchSuggestions}   visible
    Run Keyword And Continue On Failure    Get Element Count    ${SearchPage_List_SearchSuggestions} >> div   <=    5
    Scroll By    vertical=2%    behavior=smooth
    Run Keyword And Continue On Failure    Wait For Elements State    ${SearchPage_Div_SearchBoxContainer}    detached
    Click With Options    ${SearchPage_Button_SearchIcon}    delay=0.5s
    Run Keyword And Continue On Failure    Get Attribute    ${SearchPage_Input_SearchBox}    value     ==    ${SingleChar_SearchTerm}
    Click    ${SearchPage_Button_ClearSearch}
    Get Attribute    ${SearchPage_Input_SearchBox}    value     ==    ${EMPTY}

Blank Search and Obscure Search
    [Documentation]    Dubious terms gives no results, blank search doesn't go to results page
    Keyboard Key    press    Enter
    Run Keyword And Continue On Failure    Get Url    not Contains    search#q
    Fill Text    ${SearchPage_Input_SearchBox}     ${Obscure_SearchTerm}
    Keyboard Key    press    Enter
    Get Text        ${SearchPage_Div_NoResults}    ==    Please try another search term.

Validate Search Results Page
    [Documentation]    Verify result #, sorting, GA attribute and more results button
    Open Search Bar And Input Given Term    ${Regular_SearchTerm}
    Run Keyword And Continue On Failure    Get Text     ${SearchPage_Div_SearchResultsHeader#}     matches    \\d+
    Run Keyword And Continue On Failure    Get Text     ${SearchPage_Div_SearchResultsHeaderTerm}    ==      ${Regular_SearchTerm}
    Run Keyword And Continue On Failure    Get Classes    ${SearchPage_Div_SearchResultsHeaderTerm}     contains     t-heading-xl
    Run Keyword And Continue On Failure    Get Style    ${SearchPage_Button_MoreResults}     color    ==    ${Teal02}
    ${initial_count}    Get Element Count    ${SearchPage_Button_SearchResultCards}     >    1
    Run Keyword And Continue On Failure    Click    ${SearchPage_Button_MoreResults}
    Get Element Count    ${SearchPage_Button_SearchResultCards}    >    ${initial_count}
    Validate Sorting, GA and Navigation

Validate Sorting, GA and Navigation
    Run Keyword And Continue On Failure    Get Text     ${SearchPage_Dropdown_SortSelection}    *=    RELEVANCY
    Click    ${SearchPage_Dropdown_SortSelection}
    Click    [value="Newest"]
    Run Keyword And Continue On Failure    Wait For Load State
    ${newest}    Get Text    ${SearchPage_Div_FirstCard} >> .public-search-result-card-title
    Click    ${SearchPage_Dropdown_SortSelection}
    Click    [value="Oldest"]
    Run Keyword And Continue On Failure    Wait For Load State
    Run Keyword And Continue On Failure    Get Text    ${SearchPage_Div_FirstCard} >> .public-search-result-card-title     !=    ${newest}
    Run Keyword And Continue On Failure    Get Attribute       ${SearchPage_Div_FirstCard} >> a       data-a-comp        contains         Search Result Card       #Verify GA attribute
    ${destination_url}    Get Attribute       ${SearchPage_Div_FirstCard} >> a       href
    Click    ${SearchPage_Div_FirstCard}
    Wait For Condition    Url     contains    ${destination_url}

Open Search Bar And Input Given Term
    [Arguments]        ${term}
    Click    ${SearchPage_Button_SearchIcon}
    Run Keyword And Continue On Failure    Wait For Elements State     ${SearchPage_Div_SearchBoxContainer}    visible
    Fill Text    ${SearchPage_Input_SearchBox}     ${term}
    Keyboard Key    press    Enter
    Run Keyword And Continue On Failure    Wait For Condition    Text     ${SearchPage_Div_SearchResultsHeaderTerm}    ==    ${term}

Search Various Card Types
    [Documentation]    Verify title, insights, ticker and bio card types in search results
    FOR     ${key}      ${value}    IN      &{SearchType_Terms}
            Open Search Bar And Input Given Term        ${value}
            ${cards}    Get Elements        .public-search-result-card
            FOR    ${card}    IN     @{cards}
                ${title}    Run Keyword And Continue On Failure   Get Text    ${card} >> .public-search-result-card-title
                    IF     '${value}' in '${title}'
                        IF    '${key}' == 'fundname'
                            Run Keyword And Continue On Failure    Get Attribute    ${card} >> .public-search-result-card-content    href    contains    funds/dfac/us-core-equity-2-etf
                            BREAK
                        ELSE
                            Run Keyword And Continue On Failure    Get Text    ${card} >> .public-search-result-card-desc >> .t-body-xs-heavy:last-of-type    !=      ${EMPTY}
                            IF    '${key}' == 'bios'
                                Run Keyword And Continue On Failure    Get Text    ${card} >> .public-search-result-card-eyebrow     ==    BIOGRAPHIES
                                BREAK
                            ELSE IF    '${key}' == 'insights'
                                Run Keyword And Continue On Failure    Get Text    ${card} >> .public-search-result-card-eyebrow     validate    value in ('PERSPECTIVES','RESEARCH')
                                Run Keyword And Continue On Failure    Get Text    ${card} >> span.t-body-xs-italic     matches    \\d{4}$
                                BREAK
                            ELSE IF    '${key}' == 'image'
                                Run Keyword And Continue On Failure    Get Attribute    ${card} >> img    src    validate    any(v in value for v in @{Image_Extensions})
                                BREAK
                            ELSE
                                BREAK
                            END
                        END
                    END
            END
    END


Check Audience Specific Results
    [Arguments]    ${search_term}       ${notcontainsurl}
    Open Search Bar And Input Given Term        ${search_term}
    ${cards}    Get Elements        .public-search-result-card
    FOR    ${card}    IN     @{cards}
        Run Keyword And Continue On Failure   Get Attribute    ${card} >> a    href    not contains    ${notcontainsurl}
    END

Ensure Only Audience Specific Results Showup
    Run Keyword And Continue On Failure   Check Audience Specific Results    d 360    us-en/financial-professionals
    Click        ${IndHomePage_Button_AudienceSwitchCTA}
    Select Audience    professional
    Check Audience Specific Results    How To Invest    us-en/individual

Search For Non-US Countries Is Hidden
    Pass Execution    "Due to regional testing, search is enabled outside US. Need to revisit after requirements are solidified."
    Go To        ${PUBLIC_SITE_URL}/de-de/individual/
    Wait For Elements State    ${SearchPage_Button_SearchIcon}    detached