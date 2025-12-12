# This is the page object for Client Site search component, the search results page and the no results page.

*** Variables ***

# search box locators
${SearchPage_Button_SearchIcon}                 [data-qa="client-search-searchbox"]
${SearchPage_Input_SearchBox}                   [data-qa="client-search-input"]
${SearchPage_ListItem_SearchBoxSuggestion}      [data-qa="client-search-suggestion"]

# valid results page locators
${SearchPage_Button_Clear}                      [data-qa="coveo-remove-breadcrumb-button"]
${SearchPage_Button_ClearAll}                   [data-qa="coveo-clear-all-breadcrumbs"]
${SearchPage_Button_ShowMore}                   [data-qa="client-search-results-show-more-button"]
${SearchPage_Checkbox_FilterFacetCheckbox}      input[type='checkbox']
${SearchPage_Container_FilterBreadcrumbs}       [data-qa="coveo-breadcrumbs-container"]
${SearchPage_Container_FilterFacet}             [data-qa="client-search-results-filters"]
${SearchPage_Container_Filters}                 .search-page-filters
${SearchPage_Container_ResultCard}              [data-qa="client-search-result-card"]
${SearchPage_Container_Results}                 [data-qa="client-search-results-container"]
${SearchPage_Label_FilterFacetCount}            [data-qa="client-search-result-count-for-filter"]
${SearchPage_Label_FilterFacetTitle}            [data-qa="client-search-results-filter-group"]
${SearchPage_Label_ResultCardClassification}    [data-qa="client-search-result-classification"]
${SearchPage_Label_ResultCardSeries}            [data-qa="client-search-result-series"]
${SearchPage_Label_ResultsHeader}               .search-page-header-desktop >> [data-qa="client-search-number-of-results"]
@{SearchPage_Label_VisibleFacets}               USE    FORMAT    SERIES
${SearchPage_Setting_MaxCardsLimit}             28
@{SearchPage_Checkbox_FundSpecificFacets}       Fact Sheet    Performance Commentary

# no results page locators
${SearchPage_Label_NoResultsSuggestionText}     [data-qa="client-search-no-results-header"]


*** Keywords ***

Verify Search Suggestions For
    [Arguments]    ${search_text}
    Click        ${SearchPage_Button_SearchIcon}
    Fill Text   ${SearchPage_Input_SearchBox}    ${search_text}
    Evaluate JavaScript    ${SearchPage_Input_SearchBox}    (elem) => elem.click()
    Get Element Count    ${SearchPage_ListItem_SearchBoxSuggestion}    >=    0


Perform A Search For
    [Arguments]    ${search_text}
    Click        ${SearchPage_Button_SearchIcon}
    Fill Text   ${SearchPage_Input_SearchBox}    ${search_text}
    Keyboard Key    press    Enter
    Wait For Condition    Text    ${SearchPage_Label_ResultsHeader}   contains    ${search_text}


Get Results Count From Header
    ${header_text}    Get Text    ${SearchPage_Label_ResultsHeader}
    ${header_words_list}    Split String    ${header_text}    ${SPACE}
    ${count}    Get Variable Value    ${header_words_list}[1]
    RETURN    ${count}


Verify Results Are Found
    Get Element States    ${SearchPage_Container_Results}    validate    visible
    Get Element States    ${SearchPage_Label_NoResultsSuggestionText}    validate    detached
    ${results_count}    Get Results Count From Header
    Should Be True    ${results_count} > 0

    IF  ${results_count} > ${SearchPage_Setting_MaxCardsLimit}
        Get Element States    ${SearchPage_Button_ShowMore}    validate    visible
        ${cards_count}=    Set Variable    ${SearchPage_Setting_MaxCardsLimit}
        WHILE  ${cards_count}!=${results_count}
            Click    ${SearchPage_Button_ShowMore}
            Wait For Elements State    ${SearchPage_Container_Results}    visible
            ${cards_count}   Get Element Count    ${SearchPage_Container_ResultCard}
        END
    ELSE IF  ${results_count} <= ${SearchPage_Setting_MaxCardsLimit}
        Get Element States    ${SearchPage_Button_ShowMore}    validate    detached
    END


Verify No Results Are Found
    Get Element States    ${SearchPage_Label_NoResultsSuggestionText}    validate    visible
    Get Element States    ${SearchPage_Container_Results}    validate    detached

    ${results_count}    Get Results Count From Header
    Should Be True    ${results_count} == 0


Verify Single Filters
    Get Element States    ${SearchPage_Container_Filters}    validate    visible
    ${initial_results_count}    Get Results Count From Header

    ${sf_facets}    Get Elements    ${SearchPage_Container_FilterFacet}

    FOR  ${sf_facet}  IN  @{sf_facets}
        Log    Results count before applying filters: ${initial_results_count}    console=True
        ${sf_facet_title}    ${sf_facet_values}    ${sf_facet_value_text}    Apply Filters    ${sf_facet}    ${initial_results_count}
        Verify Filtered Results    ${sf_facet_title}    ${sf_facet_values}    ${sf_facet_value_text}
        Clear Individual Breadcrumb
        Wait For Condition    Text    ${SearchPage_Label_ResultsHeader}   contains    ${initial_results_count}
    END


Verify Multiple Filters
    Get Element States    ${SearchPage_Container_Filters}    validate    visible
    ${initial_results_count}    Get Results Count From Header
    Log    Results count before applying filters: ${initial_results_count}    console=True

    ${first_facets_list}    Get Elements    ${SearchPage_Container_FilterFacet}
    ${first_filter_facet}     Evaluate    random.choice($first_facets_list)
    ${first_filter_facet_title}    Get Text    ${first_filter_facet} >> ${SearchPage_Label_FilterFacetTitle}

    Apply Filters    ${first_filter_facet}    ${initial_results_count}

    ${new_results_count}    Get Results Count From Header
    Log    Results count before applying filters: ${new_results_count}    console=True

    ${updated_facets}    Get Elements    ${SearchPage_Container_FilterFacet}
    ${second_facets_list}    Create List
    FOR  ${mf_facet}  IN  @{updated_facets}
        ${mf_facet_title}    Get Text    ${mf_facet} >> ${SearchPage_Label_FilterFacetTitle}
        Run Keyword If    '${mf_facet_title}' != '${first_filter_facet_title}'   Append To List    ${second_facets_list}    ${mf_facet}
    END
    ${second_filter_facet}     Evaluate    random.choice($second_facets_list)

    Apply Filters    ${second_filter_facet}    ${new_results_count}

    Clear All Filters
    Wait For Condition    Text    ${SearchPage_Label_ResultsHeader}   contains    ${initial_results_count}


Apply Filters
    [Arguments]    ${facet}    ${initial_results_count}
    ${facet_state}    Get Element States    ${facet} >> li:first-child
    Run Keyword If    "hidden" in ${facet_state}    Click    ${facet}

    ${facet_title}    Get Text    ${facet} >> ${SearchPage_Label_FilterFacetTitle}

    ${facet_values}    Get Elements    ${facet} >> li
    ${facet_value}     Evaluate    random.choice($facet_values)

    ${full_facet_value_text}    Get Text    ${facet_value}
    ${facet_value_count}    Get Text    ${facet_value} >> ${SearchPage_Label_FilterFacetCount}
    ${facet_value_text}    Remove String    ${full_facet_value_text}    ${facet_value_count}

    Log    Applying filter facet value "${facet_value_text}" for facet "${facet_title}"    console=True

    Click    ${facet_value}
    Wait For Elements State    ${facet_value} >> ${SearchPage_Checkbox_FilterFacetCheckbox}    checked
    ${updated_results_count}    Get Results Count From Header
    Log    Results count after applying filters: ${updated_results_count}    console=True
    Should Be True    (${updated_results_count} <= ${initial_results_count}) and (${updated_results_count}>=${facet_value_count})
    RETURN    ${facet_title}    ${facet_values}    ${facet_value_text}

Verify Fund Documents Specific Filters
    ${all_facets}    Get ELements    ${SearchPage_Container_FilterFacet}
    FOR  ${facet}  IN  @{all_facets}
        ${facet_state}    Get Element States    ${facet} >> li:first-child
        Run Keyword If    "hidden" in ${facet_state}    Click    ${facet}
        Wait For Condition    Element States    ${facet} >> li:first-child    not contains    hidden
    END

    ${all_facet_values}    Get Elements    ${SearchPage_Container_FilterFacet} >> li
    ${all_title_text}    Create List
    FOR  ${facet_value}  IN  @{all_facet_values}
        ${full_text}    Get Text    ${facet_value}
        ${count}    Get Text    ${facet_value} >> ${SearchPage_Label_FilterFacetCount}
        ${title}    Remove String    ${full_text}    ${count}
        Append To List    ${all_title_text}    ${title}
        IF  '${title}' in @{SearchPage_Checkbox_FundSpecificFacets}
            ${initial_count}    Get Results Count From Header
            Log    Results count before applying filters: ${initial_count}    console=True
            Run Keyword And Continue On Failure    Click    ${facet_value}
            Log    Applying filter for ${title}    console=True
            Run Keyword And Continue On Failure    Wait For Elements State    ${facet_value} >> ${SearchPage_Checkbox_FilterFacetCheckbox}    checked
            ${new_count}    Get Results Count From Header
            Log    Results count after applying filters: ${new_count}    console=True
            Run Keyword And Continue On Failure    Should Be True    ${new_count} <= ${initial_count}
            Run Keyword And Continue On Failure    Clear All Filters
        END
    END
    Run Keyword And Continue On Failure    List Should Contain Sub List    ${all_title_text}    ${SearchPage_Checkbox_FundSpecificFacets}


Verify Filtered Results
    [Arguments]    ${facet_title}    ${facet_values}    ${facet_value_text}
    IF  '${facet_title}' in @{SearchPage_Label_VisibleFacets}
        IF  ('${facet_title}' == 'USE') or ('${facet_title}' == 'FORMAT')
            IF  '${facet_title}' == 'USE'
                FOR  ${value}  IN  @{facet_values}
                    ${text}    Get Text    ${value}
                    Should Be True    'Internal' not in '${text}'
                END
            END
            ${classifications_list}    Get Elements    ${SearchPage_Label_ResultCardClassification}
            FOR  ${classification}  IN  @{classifications_list}
                ${result_card_classification}    Get Text    ${classification}
                Should Be True    ("${facet_value_text.strip().upper()}" in "${result_card_classification}") or ("MULTIFORMAT" in "${result_card_classification}")
            END
        ELSE IF  '${facet_title}' == 'SERIES'
            ${series_list}    Get Elements    ${SearchPage_Label_ResultCardSeries}
            FOR  ${series}  IN  @{series_list}
                ${result_card_series}    Get Text    ${series}
                Should Be True    "${facet_value_text.strip().upper()}" == "${result_card_series}"
            END
        END
    END


Clear All Filters
    Log    Clearing filters...    console=True
    Wait For Elements State    ${SearchPage_Button_ClearAll}    visible
    Click    ${SearchPage_Button_ClearAll}
    Wait For Elements State    ${SearchPage_Container_FilterBreadcrumbs}    detached
    Verify All Checkboxes Are Unchecked


Clear Individual Breadcrumb
    Log    Clearing filters...    console=True
    Wait For Elements State    ${SearchPage_Button_Clear}    visible
    Click    ${SearchPage_Button_Clear}
    Wait For Elements State    ${SearchPage_Container_FilterBreadcrumbs}    detached
    Verify All Checkboxes Are Unchecked


Verify All Checkboxes Are Unchecked
    ${facet_checkboxes}    Get Elements    ${SearchPage_Container_FilterFacet} >> ${SearchPage_Checkbox_FilterFacetCheckbox}
    FOR  ${checkbox}  IN  @{facet_checkboxes}
        Get Element States    ${checkbox}    validate    unchecked
    END
