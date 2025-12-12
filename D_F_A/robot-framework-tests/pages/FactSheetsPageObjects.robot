# This is a page object for elements to be used as part of the End Of Quarter Fact Sheets validation.

*** Variables ***
# Endpoints and URLs
${fundcenter_api_endpoint}                                 https://etf.d.com/public/v2/fundcenter/funddetail?allowMorningstarFixedIncome=true
${funddetails_api_endpoint}                                https://etf.d.com/public/v2/fundcenter/
${reportcenter_portfolios_api_endpoint}                    http://products.api.d.com/api/ReportCenter/GetPortfolios
${reportcenter_fundfees_api_endpoint}                      http://publishedfunddata.api.d.com/api/ReportCenter/GetFeesForDisplay
${reportcenter_cars_portfolios_api_endpoint}               http://products.api.d.com/api/CarsPortfolios/Get
${reportcenter_equity_chars_api_endpoint}                  http://iadrest.d.com/api/v2/Characteristic/Equity/TotalCharsByVehicle
${reportcenter_getbenchmarks_endpoint}                     http://products.api.d.com/api/ReportCenter/GetPortfolioToBenchmarks
${reportcenter_net_performance_api_endpoint}               http://returns.api.d.com/api/ReportCenter/GetPortfolioNetPerformance
${reportcenter_returns_inception_years_api_endpoint}       http://returns.api.d.com/api/AverageAnnualTotalReturn/ForFactSheets
${reportcenter_returns_3month_api_endpoint}                http://returns.api.d.com/api/MonthlyReturns/GetPeriodicReturnsByPortfolio
${reportcenter_fixed_chars_api_endpoint}                   http://fixedchar.api.d.com/api/Characteristic/Fixed/TotalChars
${reportcenter_fixed_chars_ldi_api_endpoint}               http://fixedchar.api.d.com/api/Fixed/Ldi/Aggregator/Characteristics
${reportcenter_topholding_api_endpoint}                    http://iadrest.d.com/api/v2/Characteristic/Equity/TopHolding
${reportcenter_fofholding_api_endpoint}                    http://iadrest.d.com/api/Holding/FofMarketing
${reportcenter_portfolios_list_url}                        http://reportcenter.d.com/Portfolio
${reportcenter_equity_chars_allocations_api_endpoint}      http://equitychar.api.d.com/api/v2/Characteristic/Equity/Allocations
${reportcenter_calendar_year_returns_api_endpoint}         http://returns.api.d.com/api/CalendarQuarterAndYear/ForPublicWeb
${chars_equity_url}                                        http://char.dfa
${chars_fixed_url}                                         http://char-fixed.dfa
${reportcenter_asset_class_exposure_api_endpoint}          http://iadrest.d.com/api/Holding/IncomeRiskManagementAssetAllocation
${reportcenter_fixed_allocation_api_endpoint}            http://iadrest.d.com/api/Characteristic/Fixed
${reportcenter_fundaum_api_endpoint}                       http://gips.d.com/ReportCenter/GetVehiclesWithAum

# Static Texts
${fund_center_investment_objective_extra_line}             The Fund Net Assets shown represents the assets for the master fund that this portfolio invests in.\n\n
${reportcenter_api_authentication_key}                     8adc7fbb-8fd1-478d-ae02-23aa3e4ea272
${principal_risks_preceding}                               Because the value of your investment in the Portfolio will fluctuate, there is the risk that you will lose money. An investment in the Portfolio is not a deposit of a bank and is not insured or guaranteed by the Federal Deposit Insurance Corporation or any other government agency. The Portfolio’s principal risks include:
${principal_risks_succeding}                               For more information regarding the Portfolio's principal risks, please see the prospectus.

# Locators
${fund_center_link_portfolio}                              [data-qa="fund-link-placeholder"]
${fund_center_text_objective}                              [data-qa="investment-objective"] >> [class*="info-objective-contents"]
${fund_center_button_funddetailclose}                      [data-qa="close-compare-dialog-btn"]
${fund_center_label_risktypes}                             [data-qa="risks-lens"] >> xpath=//strong[contains(text(), 'Risk')]
${reportcenter_maturity_allocation_section_rows}           [id="collapse_fixedchar_PLACEHOLDER"] >> [id*="_MATU"] >> tbody >> tr
${reportcenter_basic_info_section_exchange}                [id="collapse_basic_PLACEHOLDER"] >> .row:nth-child(6) >> div:nth-child(2)
${chars_tab_vehicles}                                      \#VehiclesTab
${chars_text_search}                                       \#VehicleGrid_searchBox
${chars_tab_characteristics}                               \#CharsTab
${chars_button_createreport}                               \#CreateReportButton
${chars_radio_totalcount}                                  [value="Total"]
${chars_dropdown_vehiclegroup}                             \#VehicleGroupList
${fixedchars_checkbox_portfolio}                           [name="inst_1_PLACEHOLDER"]
${fixedchars_button_submit}                                [name="Submit2"]
${fixedchars_dropdown_sorttype}                            [name="setnumsorts"]
${fixedchars_dropdown_filter}                              [name="filter"]
${fixedchars_button_viewcharacteristics}                   [name="ViewCharacteristics"]
${fixedchars_table_rows}                                   .pba >> tr
${fixedchars_button_mainmenu}                              [name="Return to Main Menu"]

*** Keywords ***
Get Current Month and Year
    ${current_date}    Get Current Date    result_format=%Y-%m-%d
    ${current_month}   Convert To Integer    ${current_date[5:7]}
    ${current_year}    Convert To Integer    ${current_date[:4]}
    RETURN    ${current_month}    ${current_year}


Get Previous Month and Year
    ${current_month}    ${current_year}    Get Current Month and Year
    ${previous_month}    Evaluate    (${current_month} - 1) if ${current_month} > 1 else 12
    ${previous_month_year}    Evaluate    ${current_year} if ${current_month} > 1 else ${current_year} - 1
    RETURN    ${previous_month}    ${previous_month_year}


Get Last Day Of Previous Month
    ${current_month}    ${current_year}    Get Current Month and Year
    Run Keyword And Return    Evaluate    (datetime.date(${current_year}, ${current_month}, 1) - datetime.timedelta(days=1)).strftime('%Y-%m-%d')


Get Fund Center Response Data
    [Arguments]    ${portfolio_id}
    ${fund_center_headers}    Create Dictionary     X-Selected-Country=US    Content-Type=application/json     Accept=application/json        Cache-Control=no-cache
    ${fund_center_body}    Convert String To Json    {"portfolioNumber":${portfolio_id}}
    Create Session     fundcenter     ${fundcenter_api_endpoint}    headers=${fund_center_headers}    verify=True
    Run Keyword And Return    POST On Session    fundcenter    url=${None}    json=${fund_center_body}


Get All Fund Details
    ${fund_center_headers}    Create Dictionary     X-Selected-Country=US    Content-Type=application/json     Accept=application/json        Cache-Control=no-cache
    Create Session     funddetails     ${funddetails_api_endpoint}    headers=${fund_center_headers}    verify=True
    Run Keyword And Return    Get On Session    funddetails    url=${None}


Get Report Center Portfolios Response Data
    [Arguments]    ${portfolio_id}
    ${last_day_of_previous_month}    Get Last Day Of Previous Month
    ${report_center_headers}    Create Dictionary     Content-Type=application/json     Accept=application/json        Cache-Control=no-cache
    ${report_center_body}    Convert String To Json    {"PortfolioNumbers":[${portfolio_id}],"AsOfDate":"${last_day_of_previous_month}"}
    Create Session     reportcenter     ${reportcenter_portfolios_api_endpoint}    headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenter    url=${None}    json=${report_center_body}


Get Portfolios Benchmarks
    [Arguments]    ${portfolio_id}
    ${last_day_of_previous_month}    Get Last Day Of Previous Month
    ${report_center_headers}    Create Dictionary     Content-Type=application/json     Accept=application/json        Cache-Control=no-cache
    ${report_center_body}    Convert String To Json    {"PortfolioNumbers":[${portfolio_id}],"AsOfDate":"${last_day_of_previous_month}"}
    Create Session     reportcenter     ${reportcenter_getbenchmarks_endpoint}    headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenter    url=${None}    json=${report_center_body}


Get Report Center Fund Fees Response Data
    [Arguments]    ${portfolio_id}
    ${last_day_of_previous_month}    Get Last Day Of Previous Month
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache    api_key=${reportcenter_api_authentication_key}
    ${report_center_body}    Convert String To Json    {"PortfolioNumbers":[${portfolio_id}],"AsOfDate":"${last_day_of_previous_month}"}
    Create Session     reportcenter     ${reportcenter_fundfees_api_endpoint}    headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenter    url=${None}    json=${report_center_body}


Get Report Center Cars Portfolio
    [Arguments]    ${portfolio_id}
    ${last_day_of_previous_month}    Get Last Day Of Previous Month
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_body}    Convert String To Json    {"PortfolioNumbers":[${portfolio_id}],"AsOfDate":"${last_day_of_previous_month}"}
    Create Session     reportcentercarsportfolio     ${reportcenter_cars_portfolios_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcentercarsportfolio    url=${None}    json=${report_center_body}


Check Fund Costs Field Value
    [Arguments]    ${portfolio_ids}    ${field_name}
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_value}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fees.fees[?(@.name=='${field_name}')].value.display

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fund Fees Response Data    ${portfolio_id}
        ${report_center_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Fees[?(@.Name=='${field_name}')].Percentage

        Run Keyword And Continue On Failure    Run Keyword If    '${fund_center_value[0]}' != '${report_center_value[0]}%'    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    RETURN    ${failed_portfolios}


Get Report Center Portfolio Vehicle Code
    [Arguments]    ${portfolio_id}
    ${report_center_response}    Get Report Center Portfolios Response Data    ${portfolio_id}
    Run Keyword And Return    Get Value From Json    ${report_center_response.json()}    $..VehicleCode


Get Report Center Equity Characteristics Data
    [Arguments]    ${portfolio_id}    ${characteristics_type}
    ${previous_month}    ${previous_month_year}    Get Previous Month and Year
    ${report_center_vehicle_code}    Get Report Center Portfolio Vehicle Code    ${portfolio_id}
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_eq_char_body}    Convert String To Json    {"VehicleCode":"${report_center_vehicle_code}[0]","DFACurrencyCode":"USD","CharacteristicTypes":["${characteristics_type}"],"ReportDate":{"Month":"${previous_month}","Year":"${previous_month_year}"}}
    Create Session     reportcentereqchars     ${reportcenter_equity_chars_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcentereqchars    url=${None}    json=${report_center_eq_char_body}


Get Report Center 3 Month Returns
    [Arguments]    ${portfolio_id}    ${benchmark_id}
    ${previous_month}    ${previous_month_year}    Get Previous Month and Year
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_body}    Convert String To Json    {"PortfolioOrBenchmarks":["${portfolio_id}","${benchmark_id}[0]"],"IsDebug":true,"EndMonth":{"Month":"${previous_month}","Year":"${previous_month_year}"},"CurrencyCode":"USD"}
    Create Session     reportcenter3mreturns     ${reportcenter_returns_3month_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenter3mreturns    url=${None}    json=${report_center_body}


Get Report Center Inception and Yearly Returns
    [Arguments]    ${portfolio_id}    ${benchmark_id}
    ${previous_month}    ${previous_month_year}    Get Previous Month and Year
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_body}    Convert String To Json    {"BenchmarkNumbers": ${benchmark_id},"PortfolioNumber":"${portfolio_id}","EndMonth":"${previous_month}","EndYear":"${previous_month_year}"}
    Create Session     reportcenterreturns     ${reportcenter_returns_inception_years_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenterreturns    url=${None}    json=${report_center_body}


Check Annualized Returns For Period
    [Arguments]    ${portfolio_ids}    ${fund_center_period}    ${report_center_period}
    @{failed_portfolios}    Create List
    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json      ${fund_center_response.json()}      $..returns.${fund_center_period}.value
        ${report_center_benchmarks}    Run Keyword And Continue On Failure    Get Portfolios Benchmarks    ${portfolio_id}
        ${benchmark_id}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_benchmarks.json()}    $..Number
        IF  '${report_center_period}' == 'ThreeMonth'
            ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center 3 Month Returns    ${portfolio_id}    ${benchmark_id}
        ELSE
            ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Inception and Yearly Returns    ${portfolio_id}    ${benchmark_id}
        END
        ${report_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json      ${report_center_response.json()}      $..${report_center_period}.Value
        ${fund_center_annualized_performance}    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${fund_center_raw_value}[0] * 100)
        ${fund_center_annualized_performance_benchmark}    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${fund_center_raw_value}[1] * 100)
        ${report_center_annualized_performance}    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${report_center_raw_value}[0] * 100)
        ${report_center_annualized_performance_benchmark}    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${report_center_raw_value}[1] * 100)

        Run Keyword And Continue On Failure    Run Keyword If
        ...    ${fund_center_annualized_performance} != ${report_center_annualized_performance} or ${fund_center_annualized_performance_benchmark} != ${report_center_annualized_performance_benchmark}
        ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    RETURN    ${failed_portfolios}


Get Report Center Fixed Income Characteristics Data
    [Arguments]    ${portfolio_id}
    ${last_day_of_previous_month}    Get Last Day Of Previous Month
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_fi_char_body}    Convert String To Json    {"DataDate": "${last_day_of_previous_month}","Portfolios":[{"PortBenchId": "${portfolio_id}","BaseCurrency": "USD"}]}
    Create Session     reportcenterfichars     ${reportcenter_fixed_chars_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenterfichars    url=${None}    json=${report_center_fi_char_body}


Get Report Center Fixed Income LDI Characteristics Data
    [Arguments]    ${portfolio_id}    ${characteristics_type}
    ${last_day_of_previous_month}    Get Last Day Of Previous Month
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache    api_key=${reportcenter_api_authentication_key}
    ${report_center_fi_ldi_char_body}    Convert String To Json    {"PortfolioNumbers":[${portfolio_id}],"BenchmarkNumbers":[],"ReportingDate":"${last_day_of_previous_month}","CharTypes":[${characteristics_type}],"FilterIds":[15]}
    Create Session     reportcenterfildichars     ${reportcenter_fixed_chars_ldi_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenterfildichars    url=${None}    json=${report_center_fi_ldi_char_body}


Get Report Center Top Holdings Data
    [Arguments]    ${portfolio_id}    ${report_center_vehicle_code}
    ${previous_month}    ${previous_month_year}    Get Previous Month and Year
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_top_holdings_body}    Convert String To Json    {"VehicleCodes":["${report_center_vehicle_code}[0]"],"ReportDate":{"Month":"${previous_month}","Year":"${previous_month_year}"}}
    Create Session     reportcentertopholdings     ${reportcenter_topholding_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcentertopholdings    url=${None}    json=${report_center_top_holdings_body}

Get Report Center Country Allocations - Fixed
    [Arguments]    ${portfolio_id}    ${allocation_id}
    ${last_day_of_previous_month}    Get Last Day Of Previous Month
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_allocations_body}    Convert String To Json    {"PortBenchId":${portfolio_id},"ReportDate":"${last_day_of_previous_month}","FilterIds":[${allocation_id}]}
    Create Session     reportcenterallocations     ${reportcenter_fixed_allocation_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenterallocations    url=${None}    json=${report_center_allocations_body}

Get Report Center FoF Holdings Data
    [Arguments]    ${portfolio_id}
    ${last_day_of_previous_month}    Get Last Day Of Previous Month
    ${report_center_vehicle_code}    Get Report Center Portfolio Vehicle Code    ${portfolio_id}
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_fof_holdings_body}    Convert String To Json    {"MonthEndDate":"${last_day_of_previous_month}","VehicleCodes":["${report_center_vehicle_code}[0]"]}
    Create Session     reportcenterfofholdings     ${reportcenter_fofholding_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenterfofholdings    url=${None}    json=${report_center_fof_holdings_body}


Check FoF Holdings Breakdown
    [Arguments]    ${portfolio_ids}    ${FoF_Type}
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_fof_holdings_names}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fofHoldings[?@.assetClassName == "${FoF_Type}"].name
        ${fund_center_fof_holdings_percentages}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fofHoldings[?@.assetClassName == "${FoF_Type}"].weight.display
        Sort List    ${fund_center_fof_holdings_names}
        Sort List    ${fund_center_fof_holdings_percentages}
        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fof Holdings Data    ${portfolio_id}
        ${report_center_fof_holdings_portfolios}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..SubfundHoldings[?@.InvestmentStyleAssetClass == "${FoF_Type}"].ChildPortfolioNumber

        ${report_center_fof_holdings_names}    Create List
        FOR    ${portfolio}    IN    @{report_center_fof_holdings_portfolios}
            ${rc_response}    Run Keyword And Continue On Failure    Get Report Center Portfolios Response Data    ${portfolio}
            ${report_center_marketing_name}    Run Keyword And Continue On Failure    Get Value From Json    ${rc_response.json()}    $..MarketingName
            Append To List    ${report_center_fof_holdings_names}    ${report_center_marketing_name}[0]
        END
        ${report_center_fof_holdings_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..SubfundHoldings[?@.InvestmentStyleAssetClass == "${FoF_Type}"].Weight
        ${report_center_fof_holdings_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % (value * 100) for value in ${report_center_fof_holdings_raw_values}]
        Sort List    ${report_center_fof_holdings_names}
        Sort List    ${report_center_fof_holdings_percentages}

        Run Keyword And Continue On Failure    Run Keyword If
        ...    $fund_center_fof_holdings_names != $report_center_fof_holdings_names or $fund_center_fof_holdings_percentages != $report_center_fof_holdings_percentages
        ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    RETURN    ${failed_portfolios}


Get Report Center Equity Chars Allocations Data
    [Arguments]    ${portfolio_id}    ${allocation_type}
    ${previous_month}    ${previous_month_year}    Get Previous Month and Year
    ${report_center_vehicle_code}    Get Report Center Portfolio Vehicle Code    ${portfolio_id}
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_eq_allocations_body}    Convert String To Json    {"AllocationIds":[${allocation_type}],"VehicleCodes":["${report_center_vehicle_code}[0]"],"RequestDate":{"Month":"${previous_month}","Year":"${previous_month_year}"}}
    Create Session     reportcentereqallocations     ${reportcenter_equity_chars_allocations_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcentereqallocations    url=${None}    json=${report_center_eq_allocations_body}


Get Report Center Calendar Year Returns Data
    [Arguments]    ${portfolio_or_benchmark_id}
    ${previous_month}    ${previous_month_year}    Get Previous Month and Year
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_cyreturns_body}    Convert String To Json    {"PortfolioOrBenchmarkNumbers": [${portfolio_or_benchmark_id}],"EndMonth": "${previous_month}","EndYear": "${previous_month_year}","CurrencyCode": "USD"}
    Create Session     reportcentercyreturns     ${reportcenter_calendar_year_returns_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcentercyreturns    url=${None}    json=${report_center_cyreturns_body}


Check Fixed Income Number Of Holdings
    [Arguments]    ${portfolio_id}
    @{failed_fi_portfolios}    Create List
    ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
    ${fund_center_holdings_raw}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.chars[?(@.name=="Number of Holdings")].value.value
    ${fund_center_holdings_final}    Run Keyword And Continue On Failure    Evaluate    int(${fund_center_holdings_raw}[0])
    ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fixed Income Characteristics Data    ${portfolio_id}
    ${report_center_holdings_raw}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Results['${portfolio_id}:USD'][?(@.Name=="Number of Holdings")].Value
    ${report_center_holdings_final}    Run Keyword And Continue On Failure    Evaluate    int(${report_center_holdings_raw}[0])
    Run Keyword And Continue On Failure   Log    \nPORTFOLIO ID IS ${portfolio_id} AND # OF FI HOLDINGS ARE ${fund_center_holdings_final}/${report_center_holdings_final}   console=True
    Run Keyword And Continue On Failure    Run Keyword If    $fund_center_holdings_final != $report_center_holdings_final    Run Keywords    Append To List    ${failed_fi_portfolios}    ${portfolio_id}    AND     Fail
    RETURN    ${failed_fi_portfolios}


Check Equity Number Of Holdings
    [Arguments]    ${portfolio_id}
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${chars_equity_url}
    @{failed_eq_portfolios}    Create List
    ${report_center_vehicle_code}    Get Report Center Portfolio Vehicle Code    ${portfolio_id}
    Run Keyword And Continue On Failure    Wait For Elements State    ${chars_tab_vehicles}    visible    30s
    IF    '${report_center_vehicle_code[0]}' in ['LCAP', 'VALU']
        Run Keyword And Continue On Failure    Select Options By    ${chars_dropdown_vehiclegroup}    value    3
    ELSE IF    '${report_center_vehicle_code[0]}' in ['FUND','REIT', 'VECT']
        Run Keyword And Continue On Failure    Select Options By    ${chars_dropdown_vehiclegroup}    value    1
    END

    IF    '${report_center_vehicle_code[0]}'=='VALU'
        Run Keyword And Continue On Failure    Type Text    ${chars_text_search}    DFA
    ELSE
        Run Keyword And Continue On Failure    Type Text    ${chars_text_search}    ${report_center_vehicle_code[0]}
    END

    Run Keyword And Continue On Failure    Click    text="${report_center_vehicle_code[0]}"
    Run Keyword And Continue On Failure    Click    ${chars_tab_characteristics}
    Run Keyword And Continue On Failure    Click    text="Number of Holdings"
    Run Keyword And Continue On Failure    Click    ${chars_button_createreport}
    Run Keyword And Continue On Failure    Click    ${chars_radio_totalcount}
    ${char_holdings}    Run Keyword And Continue On Failure    Get Text    [id^="ReportGrid_row"]>td:nth-child(5)>div>div
    ${char_holdings_int}    Run Keyword And Continue On Failure    Evaluate    int(${char_holdings.replace(',','')})
    ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Equity Characteristics Data    ${portfolio_id}    number-of-holdings
    ${report_center_holdings_raw}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..number-of-holdings.Value.Value
    ${report_center_holdings_final}    Run Keyword And Continue On Failure    Evaluate    int(${report_center_holdings_raw[0]})
    Run Keyword And Continue On Failure   Log    \nPORTFOLIO ID IS ${portfolio_id}, VEHICLE CODE IS ${report_center_vehicle_code[0]} AND # OF EQ HOLDINGS ARE ${char_holdings_int}/${report_center_holdings_final}   console=True
    Run Keyword And Continue On Failure    Run Keyword If    $char_holdings_int != $report_center_holdings_final    Run Keywords    Append To List    ${failed_eq_portfolios}    ${portfolio_id}    AND     Fail
    RETURN    ${failed_eq_portfolios}


Get Report Center Asset Class Exposure Data
    [Arguments]    ${portfolio_id}    ${vehicle_code}
    ${last_day_of_previous_month}    Get Last Day Of Previous Month
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_asset_exposure_returns_body}    Convert String To Json    {"MonthEndDate":"${last_day_of_previous_month}","AsOfRunUtc": null,"VehicleCodes":["${vehicle_code}"]}
    Create Session     reportcenterassetclassexposure     ${reportcenter_asset_class_exposure_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenterassetclassexposure    url=${None}    json=${report_center_asset_exposure_returns_body}


Check Asset Class Exposure
    [Arguments]    ${portfolio_ids}    ${fund_center_allocation_type}    ${report_center_allocation_type}
    @{failed_portfolios}    Create List
    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_all_allocations}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?(@.data.name=="Asset Allocation")]..allocations
        ${fund_center_asset_exposure_raw_values}    Run Keyword And Continue On Failure    Evaluate    [alloc['weight']['value'] for alloc in ${fund_center_all_allocations}[0] if '${fund_center_allocation_type}' in alloc['name']]
        ${fund_center_asset_exposure}    Run Keyword And Continue On Failure    Evaluate    '%.2f%%' % (sum([float(x) for x in ${fund_center_asset_exposure_raw_values}]) * 100)

        ${report_center_vehicle_code}    Run Keyword And Continue On Failure    Get Report Center Portfolio Vehicle Code    ${portfolio_id}
        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Asset Class Exposure Data    ${portfolio_id}    ${report_center_vehicle_code}[0]
        ${report_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..["${report_center_vehicle_code}[0]"]\[?(@.Key == "${report_center_allocation_type}")].Weight
        ${report_center_asset_exposure}    Run Keyword And Continue On Failure    Evaluate    '%.2f%%' % float(${report_center_raw_value}[0])

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_asset_exposure != $report_center_asset_exposure    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    RETURN    ${failed_portfolios}


Get Report Center REIT Industries Data
    [Arguments]    ${portfolio_id}
    ${previous_month}    ${previous_month_year}    Get Previous Month and Year
    ${report_center_vehicle_code}    Get Report Center Portfolio Vehicle Code    ${portfolio_id}
    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_reit_industries_body}    Convert String To Json    {"RequestDate":{"Year":${previous_month_year},"Month":${previous_month}},"VehicleCodes":["${report_center_vehicle_code}[0]"],"AllocationIds":[9]}
    Create Session     reportcenterreitindustries     ${reportcenter_equity_chars_allocations_api_endpoint}   headers=${report_center_headers}    verify=True
    Run Keyword And Return    POST On Session    reportcenterreitindustries    url=${None}    json=${report_center_reit_industries_body}


Get Report Center Fund Aum Response Data
    [Arguments]    ${portfolio_id}
    ${current_month}    ${current_year}    Get Current Month and Year
    ${report_center_port_response}    Get Report Center Portfolios Response Data    ${portfolio_id}
    ${report_center_vehiclecode}    Get Value From Json    ${report_center_port_response.json()}    $..VehicleCode

    @{creds}    Set Variable    dfa_primary    ${AD_Username}    ${AD_Password}

    ${report_center_headers}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cache-Control=no-cache
    ${report_center_aum_body}    Convert String To Json    {"Month":"${current_month}","Year":"${current_year}","VehicleAndCurrencies":[{"VehicleCode":"${report_center_vehiclecode}[0]","CurrencyCode":"USD"}],"HasVehicles":"true"}
    Create NTLM Session     reportcenter     ${reportcenter_fundaum_api_endpoint}    headers=${report_center_headers}    auth=${creds}
    Run Keyword And Return    GET On Session    reportcenter    url=${None}    json=${report_center_aum_body}