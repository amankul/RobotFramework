*** Settings ***
Library        Browser
Resource       ../env/${environment}.resource
Resource       ../pages/GlobalKeywords.robot
Resource       ../pages/GlobalVariables.robot
Resource       ../pages/FactSheetsPageObjects.robot
Suite Setup    Run Keywords    Get-Credentials
Test Setup     Initialize Browser
Test Timeout       10 minutes

*** Test Cases ***
Verify Header - Fund Name
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the marketing name for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    5
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_marketing_name}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fundFacts..marketingName

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Portfolios Response Data    ${portfolio_id}
        ${report_center_marketing_name}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..MarketingName

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_marketing_name[0] != $report_center_marketing_name[0]    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Marketing name does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Overview - Inception Date
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the inception date for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    9
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_inception_date}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fundFacts..inceptionDate[value]

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Portfolios Response Data    ${portfolio_id}
        ${report_center_inception_date}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..InceptionDate

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_inception_date[0] != $report_center_inception_date[0][:10]    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Inception date does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Overview - Benchmarks
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the benchmark for a portfolio match between the fund center and the report center. Note even though fund center may
    ...    return multiple only first one is shown on Fact Sheets and hence used for validation here.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    8
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_benchmark_names}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fundFacts.benchmarks[0]
        ${report_center_benchmarks}    Run Keyword And Continue On Failure    Get Portfolios Benchmarks    ${portfolio_id}
        ${benchmark_ids}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_benchmarks.json()}    $..Number
        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Inception and Yearly Returns    ${portfolio_id}    ${benchmark_ids}
        ${report_center_benchmark_names}      Run Keyword And Continue On Failure    Get Value From Json      ${report_center_response.json()}      $..Benchmarks..Name
        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_benchmark_names != $report_center_benchmark_names    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Benchmarks do not match for the following portfolios: ${failed_portfolios}    console=True


Verify Overview - Ticker
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the ticker symbol for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    10
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_ticker}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fundFacts..identifier[value]

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Portfolios Response Data    ${portfolio_id}
        ${report_center_ticker}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..TickerSymbol

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_ticker[0] != $report_center_ticker[0]    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Ticker does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Overview - Intraday Value Ticker
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the intraday ticker for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    11
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_intraday_ticker}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fundFacts..intradayTicker[value]

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Portfolios Response Data    ${portfolio_id}
        ${report_center_intraday_ticker}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..IntradayTicker

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_intraday_ticker[0] != $report_center_intraday_ticker[0]    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Ticker does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Overview - CUSIP
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the CUSIP for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    12
    @{failed_portfolios}    Create List
    ${fund_center_response}    Run Keyword And Continue On Failure    Get All Fund Details
    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_cusip}    Run Keyword And Continue On Failure    Get value from json      ${fund_center_response.json()}      $..portfolios[?(@.portfolioNumber==${portfolio_id})]..identifiers[?(@.name=="CUSIP")].value
        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Cars Portfolio    ${portfolio_id}
        ${report_center_cusip}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Cusip
        Run Keyword And Continue On Failure    Run Keyword If    '${fund_center_cusip[0]}' != '${report_center_cusip[0]}'    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    CUSIP does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Overview - Exchange
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Exchange for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    13
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_exchange}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..exchangeName

        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${reportcenter_portfolios_list_url}
        ${data_id}    Get Attribute    [id="DataUpdateId"] > option:nth-child(1)    value
        Go To    ${reportcenter_portfolios_list_url}/Detail?portfolioNumber=${portfolio_id}&dataUpdateId=${data_id}&currency=USD
        ${report_center_exchange}    Get Text    ${reportcenter_basic_info_section_exchange.replace("PLACEHOLDER","${portfolio_id}")}

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_exchange[0] != $report_center_exchange    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Exchange does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Overview - Fund AUM
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Fund AUM for a portfolio matches between the fund center and the report center.
    # NOTE: This test has to be run on Day 1 of any new quarter as the values are always as of previous day.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    14
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_raw_aum}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fundAum..aum..value
        ${fund_center_aum}    Run Keyword And Continue On Failure    Evaluate    '{:.1f}B'.format(round(float(${fund_center_raw_aum}[0])/1e9, 1)) if float(${fund_center_raw_aum}[0]) >= 1e9 else '{:.1f}M'.format(round(float(${fund_center_raw_aum}[0])/1e6, 1))

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fund Aum Response Data    ${portfolio_id}
        ${report_center_raw_aum}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Aum
        ${report_center_aum}    Run Keyword And Continue On Failure    Evaluate    '{:.1f}B'.format(round(float(${report_center_raw_aum}[0])/1e9, 1)) if float(${report_center_raw_aum}[0]) >= 1e9 else '{:.1f}M'.format(round(float(${report_center_raw_aum}[0])/1e6, 1))

        Log    \nPortfolio:${portfolio_id}    console=true
        Log    Fund Center AUM: ${fund_center_aum}    console=true
        Log    Report Center AUM: ${report_center_aum}\n    console=true
        Log    ------------------------    console=true

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_aum != $report_center_aum    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Fund AUM does not match for the following portfolios: ${failed_portfolios}    console=True


Verify FactSheet - Investment Objective
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the investment objective for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    15
    @{failed_portfolios}    Create List
    Set To Dictionary    ${browser_opt}    args=["--disable-web-security"]
    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/funds

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        Run Keyword And Continue On Failure    Click    ${fund_center_link_portfolio.replace("placeholder", "${portfolio_id}")}
        Run Keyword And Continue On Failure    Wait For Condition    Element States    ${fund_center_text_objective}    contains    visible    timeout=60
        ${fund_center_objective}    Run Keyword And Continue On Failure    Get Text    ${fund_center_text_objective}
        Run Keyword And Continue On Failure    Click    ${fund_center_button_funddetailclose}

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Portfolios Response Data    ${portfolio_id}
        ${report_center_objective}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Objective

        Run Keyword And Continue On Failure    Run Keyword If    ${portfolio_id} in [6, 7, 12, 27, 35, 45, 56, 67, 68, 90, 92, 95]    Set List Value    ${report_center_objective}    0    ${fund_center_investment_objective_extra_line}${report_center_objective}[0]
        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_objective != $report_center_objective[0]    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Investment objective does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Characteristics - % In Top Holdings
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the % In Top Holdings for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    18
    # The ETF portfolios 1409 and 1423 always return values as of current date instead of last day of previous month.
    # Discussed with MK and intentionally removed them from the automation validation to be checked manually
    # instead of implementing a new approach to validate from chars website.
    Remove Values From List    ${portfolio_ids}    ${1409}    ${1423}
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_holdings_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?(@.data.name == "Equity Top Holdings")]..topHoldings..weight.value
        ${fund_center_percentage_in_top_holdings}    Run Keyword And Continue On Failure    Evaluate    '%.2f' % (sum([float(x) for x in ${fund_center_holdings_raw_values}[:10]]) * 100)

        ${report_center_vehicle_code}    Get Report Center Portfolio Vehicle Code    ${portfolio_id}
        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Top Holdings Data    ${portfolio_id}    ${report_center_vehicle_code}
        ${report_center_holdings_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..["${report_center_vehicle_code}[0]"]\[?@.Rank == 10]..Cumulative
        ${report_center_percentage_in_top_holdings}    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${report_center_holdings_raw_values}[0])

        Run Keyword And Continue On Failure    Run Keyword If
        ...    $fund_center_percentage_in_top_holdings != $report_center_percentage_in_top_holdings
        ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    % In Top Holdings does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Characteristics - Wtd. Avg. Mkt. Cap. (Millions)
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Wtd. Avg. Mkt. Cap. (Millions) for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    19
    @{failed_portfolios}    Create List
    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.chars[?(@.name=="Weighted Average Total Market Capitalization (millions)")].value.value
        ${fund_center_wtd_avg_mkt_cap}    Run Keyword And Continue On Failure    Evaluate    "$" + "{:,}".format(int(round(${fund_center_raw_value}[0])))

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Equity Characteristics Data    ${portfolio_id}    weighted-average-total-market-capitalization-mm
        ${report_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..weighted-average-total-market-capitalization-mm.Value.Value
        ${report_center_wtd_avg_mkt_cap}    Run Keyword And Continue On Failure    Evaluate    "$" + "{:,}".format(int(round(${report_center_raw_value}[0])))

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_wtd_avg_mkt_cap != $report_center_wtd_avg_mkt_cap    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Wtd. Avg. Mkt. Cap. (Millions) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Characteristics - Price-to-Book
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Price-to-Book for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    20
    @{failed_portfolios}    Create List
    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.chars[?(@.name=="Aggregate Price-To-Book")].value.value
        ${fund_center_price_to_book}    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${fund_center_raw_value}[0])

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Equity Characteristics Data    ${portfolio_id}    aggregate-price-to-book-value-no-negatives
        ${report_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..aggregate-price-to-book-value-no-negatives.Value.Value
        ${report_center_price_to_book}    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${report_center_raw_value}[0])

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_price_to_book != $report_center_price_to_book    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Price-to-Book does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Characteristics - Annual Turnover
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the annual turnover for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    21
    # Fund center does not return Annual Turnover for Portfolios 904, 907, 920. These are validated using Published Fund Fee Tool instead.
    # Skipping these portfolios for now till we have a way to connect to publish fund fee tool.
    Remove Values From List    ${portfolio_ids}    ${904}    ${907}    ${920}
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_annual_turnover}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fundFacts..turnover..value..display

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fund Fees Response Data    ${portfolio_id}
        ${report_center_annual_turnover}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..FiscalYearTurnover

        Run Keyword And Continue On Failure    Run Keyword If    '${fund_center_annual_turnover[0].replace('.00','')}' != '${report_center_annual_turnover[0]}%'    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Annual turnover does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Characteristics - Average Maturity (Years)
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Average Maturity (Years) for a portfolio matches between the fund center and the report center.
    ...
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    22
    @{failed_portfolios}    Create List
    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_average_maturity_years}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.chars[?(@.name=="Weighted Average Maturity (years)")].value.display

        # The following two portfolios are returning Income Risk Management Characteristics on the fund center side.
        # However, as confirmed by MK these values are intentionally being dropped for these portfolios in the fact sheet. She has checked back to 2021.
        # Additionally, the report center is also not returning values for them which could also be intentional.
        # Hence removing the Income Risk Management Characteristics values and just keeping the Global Fixed Income Characteristics.
        Run Keyword If    ${portfolio_id} in [867, 868]    Remove Values From List    ${fund_center_average_maturity_years}    ${fund_center_average_maturity_years}[1]

        @{report_center_average_maturity_years}    Create List

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fixed Income Characteristics Data    ${portfolio_id}
        ${report_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Results['${portfolio_id}:USD'][?(@.Name=="Average Maturity (Years)")].Value
        ${report_center_bond_average_maturity_years}    Run Keyword If    ${report_center_raw_value} != []    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${report_center_raw_value}[0])
        Run Keyword If    ${report_center_bond_average_maturity_years} != ${None}    Append To List    ${report_center_average_maturity_years}    ${report_center_bond_average_maturity_years}

        ${report_center_ldi_response}    Run Keyword And Continue On Failure    Get Report Center Fixed Income LDI Characteristics Data    ${portfolio_id}    4
        ${report_center_ldi_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_ldi_response.json()}    $..CharValue
        ${report_center_ldi_average_maturity_years}    Run Keyword If    ${report_center_ldi_raw_value} != []    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${report_center_ldi_raw_value}[0])
        Run Keyword If    ${report_center_ldi_average_maturity_years} != ${None}    Append To List    ${report_center_average_maturity_years}    ${report_center_ldi_average_maturity_years}

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_average_maturity_years != $report_center_average_maturity_years    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Average Maturity (Years) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Characteristics - Yield to Maturity
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Yield to Maturity for a portfolio matches between the fund center and the report center.
    ...                NOTE: As per MK, legal might have asked us for portfolio 727 to show a - (dash) on the Fact Sheet even when the data is not available.
    ...                She also sees a ticket out for MKT asking Tech to remove these lines which is contradictory. She will investigate and confirm - may take time.
    ...                Meanwhile, removing it from our validation to avoid failure. There is an open item on Questions and Findings tab in MKT sheet.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    23
    Remove Values From List    ${portfolio_ids}    ${727}

    @{failed_portfolios}    Create List
    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_yield_to_maturity}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..chars[?(@.name=="Yield To Maturity")].value.display

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fixed Income Characteristics Data    ${portfolio_id}
        ${report_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Results['${portfolio_id}:USD'][?(@.Name=="Yield to Maturity (%)")].Value
        ${report_center_yield_to_maturity}    Run Keyword And Continue On Failure    Evaluate    '%.2f%%' % float(${report_center_raw_value}[0])

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_yield_to_maturity[0] != $report_center_yield_to_maturity    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Yield to Maturity does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Characteristics - 30 Day SEC Yield
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the 30 Day SEC Yield for a portfolio matches between the fund center and the report center.
    ...                NOTE: As per MK, legal might have asked us for portfolio 727 to show a - (dash) on the Fact Sheet even when the data is not available.
    ...                She also sees a ticket out for MKT asking Tech to remove these lines which is contradictory. She will investigate and confirm - may take time.
    ...                Meanwhile, removing it from our validation to avoid failure. There is an open item on Questions and Findings tab in MKT sheet.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    24
    Remove Values From List    ${portfolio_ids}    ${727}

    @{failed_portfolios}    Create List
    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_30_day_sec_yield}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..chars[?(@.name=="30 Day SEC Yield")].value.display

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fixed Income Characteristics Data    ${portfolio_id}
        ${report_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Results['${portfolio_id}:USD'][?(@.Name=="30-Day SEC Yield (%)")].Value
        ${report_center_30_day_sec_yield}    Run Keyword And Continue On Failure    Evaluate    '%.2f%%' % float(${report_center_raw_value}[0])

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_30_day_sec_yield[0] != $report_center_30_day_sec_yield    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    30 Day SEC Yield does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Characteristics - Average Duration (Years)
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Average Duration (Years) for a portfolio matches between the fund center and the report center.
    ...
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    25
    @{failed_portfolios}    Create List
    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_average_duration_years}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.chars[?(@.name=="Weighted Average Effective Duration (years)")].value.display

        # The following two portfolios are returning Income Risk Management Characteristics on the fund center side.
        # However, as confirmed by MK these values are intentionally being dropped for these portfolios in the fact sheet. She has checked back to 2021.
        # Additionally, the report center is also not returning values for them which could also be intentional.
        # Hence removing the Income Risk Management Characteristics values and just keeping the Global Fixed Income Characteristics.
        Run Keyword If    ${portfolio_id} in [867, 868]    Remove Values From List    ${fund_center_average_duration_years}    ${fund_center_average_duration_years}[1]

        @{report_center_average_duration_years}    Create List

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fixed Income Characteristics Data    ${portfolio_id}
        ${report_center_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Results['${portfolio_id}:USD'][?(@.Name=="Average Duration (Years)")].Value
        ${report_center_bond_average_duration_years}    Run Keyword If    ${report_center_raw_value} != []    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${report_center_raw_value}[0])
        Run Keyword If    ${report_center_bond_average_duration_years} != ${None}    Append To List    ${report_center_average_duration_years}    ${report_center_bond_average_duration_years}

        ${report_center_ldi_response}    Run Keyword And Continue On Failure    Get Report Center Fixed Income LDI Characteristics Data    ${portfolio_id}    5
        ${report_center_ldi_raw_value}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_ldi_response.json()}    $..CharValue
        ${report_center_ldi_average_duration_years}    Run Keyword If    ${report_center_ldi_raw_value} != []    Run Keyword And Continue On Failure    Evaluate    '%.2f' % float(${report_center_ldi_raw_value}[0])
        Run Keyword If    ${report_center_ldi_average_duration_years} != ${None}    Append To List    ${report_center_average_duration_years}    ${report_center_ldi_average_duration_years}

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_average_duration_years != $report_center_average_duration_years    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Average Duration (Years) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Costs - Management Fee
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the management fee for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    53
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Fund Costs Field Value    ${portfolio_ids}    Management Fee
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Management fee does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Costs - Management Fee After Fee Waiver
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the management fee after fee waiver for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    54
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Fund Costs Field Value    ${portfolio_ids}    Management Fee After Fee Waiver
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Management fee after fee waiver does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Costs - Gross Expense Ratio
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the gross expense ratio for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    55
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Fund Costs Field Value    ${portfolio_ids}    Gross Expense Ratio
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Gross expense ratio does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Costs - Net Expense Ratio (to investor)
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the net expense ratio (to investor) for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    56
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Fund Costs Field Value    ${portfolio_ids}    Net Expense Ratio (to investor)
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Net expense ratio (to investor) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Costs - Fee Waiver Disclosure
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the fee waiver disclosure for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    57
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_fee_waiver_disclosure}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..fees..disclosure

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Fund Fees Response Data    ${portfolio_id}
        ${report_center_fee_waiver_disclosure}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..FeeDisclosure

        Run Keyword And Continue On Failure    Run Keyword If    $fund_center_fee_waiver_disclosure[0] != $report_center_fee_waiver_disclosure[0]    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Fee waiver disclosure does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Document - Top Holdings
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Top Holdings for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    48
    # The ETF portfolios 1409 and 1423 always return values as of current date instead of last day of previous month.
    # Discussed with MK and intentionally removed them from the automation validation to be checked manually
    # instead of implementing a new approach to validate from chars website.
    Remove Values From List    ${portfolio_ids}    ${1409}    ${1423}
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_top_holdings_names}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?(@.data.name == "Equity Top Holdings")]..topHoldings..name
        ${fund_center_top_holdings_percentages}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?(@.data.name == "Equity Top Holdings")]..topHoldings..weight.display

        ${report_center_vehicle_code}    Get Report Center Portfolio Vehicle Code    ${portfolio_id}
        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Top Holdings Data    ${portfolio_id}    ${report_center_vehicle_code}
        ${report_center_top_holdings_names}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..["${report_center_vehicle_code}[0]"]\[?@.Rank <= 10]..Name
        ${report_center_holdings_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..["${report_center_vehicle_code}[0]"]\[?@.Rank <= 10]..Weight
        ${report_center_top_holdings_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % value for value in ${report_center_holdings_raw_values}]

        Run Keyword And Continue On Failure    Run Keyword If
        ...    $fund_center_top_holdings_names != $report_center_top_holdings_names or $fund_center_top_holdings_percentages != $report_center_top_holdings_percentages
        ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Top Holdings does not match for the following portfolios: ${failed_portfolios}    console=True



Verify Fund of Fund Holdings - Equity Breakdown
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Equity Breakdown for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    26
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check FoF Holdings Breakdown    ${portfolio_ids}    Equity
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Equity Breakdown does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund of Fund Holdings - Fixed Income Breakdown
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Fixed Income Breakdown for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    27
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check FoF Holdings Breakdown    ${portfolio_ids}    Fixed Income/Interest
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Fixed Income Breakdown does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Document - Sector Allocation
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Sector Allocation for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    50
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_sector_names}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?@.data.name=="Equity Allocation by Sector"]..allocations[?@.name != "Other"].name
        Sort List    ${fund_center_sector_names}

        ${fund_center_sector_percentage_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?@.data.name=="Equity Allocation by Sector"]..allocations[?@.name != "Other"].weight.value
        ${fund_center_sector_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % (value * 100) for value in ${fund_center_sector_percentage_raw_values}]
        Sort List    ${fund_center_sector_percentages}

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Equity Chars Allocations Data    ${portfolio_id}      6
        ${report_center_sector_names}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Allocations[?@.Key != "Other"]..Key
        Sort List    ${report_center_sector_names}

        ${report_center_sector_percentage_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Allocations[?@.Key != "Other"]..Weight
        ${report_center_sector_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % value for value in ${report_center_sector_percentage_raw_values}]
        Sort List    ${report_center_sector_percentages}

        Run Keyword And Continue On Failure    Run Keyword If
        ...    $fund_center_sector_names != $report_center_sector_names or $fund_center_sector_percentages != $report_center_sector_percentages
        ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Sector Allocation does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Document - Credit Allocation
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Credit Allocation for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    51
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_credit_names}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?@.data.name=="Fixed Income Allocation by Credit Rating with TBA Cash Offset"]..allocations..name
        IF  'BB / B' in ${fund_center_credit_names}
            Remove Values From List    ${fund_center_credit_names}    BB / B
            Append To List    ${fund_center_credit_names}    Non-Investment Grade
        END
        Sort List    ${fund_center_credit_names}

        ${fund_center_credit_percentage_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?@.data.name=="Fixed Income Allocation by Credit Rating with TBA Cash Offset"]..allocations..weight.value
        ${fund_center_credit_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % (value * 100) for value in ${fund_center_credit_percentage_raw_values}]
        Sort List    ${fund_center_credit_percentages}

        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${reportcenter_portfolios_list_url}
        ${data_id}    Get Attribute    [id="DataUpdateId"] > option:nth-child(1)    value
        Go To    ${reportcenter_portfolios_list_url}/Detail?portfolioNumber=${portfolio_id}&dataUpdateId=${data_id}&currency=USD
        ${report_center_credit_names}    Create List
        ${report_center_credit_percentage_raw_values}   Create List
        ${report_center_credit_values}    Get Elements    [id="collapse_fixedchar_${portfolio_id}"] >> [id*="_CRED"] >> tbody >> tr

        FOR  ${value}  IN  @{report_center_credit_values}
            ${name}    Get Property    ${value} >> td:nth-child(1)    textContent
            ${rating}    Get Property    ${value} >> td:nth-child(2)    textContent
            IF    $rating != ''
                Append To List    ${report_center_credit_names}    ${name}
                Append To List    ${report_center_credit_percentage_raw_values}    ${rating}
            END
        END

        ${report_center_credit_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % float(value) for value in ${report_center_credit_percentage_raw_values}]

        Sort List    ${report_center_credit_names}
        Sort List    ${report_center_credit_percentages}

        Run Keyword And Continue On Failure    Run Keyword If
        ...    $fund_center_credit_names != $report_center_credit_names or $fund_center_credit_percentages != $report_center_credit_percentages
        ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Credit Allocation does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Document - Maturity Allocation
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Maturity Allocation for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    52
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_maturity_names}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?@.data.name=="Fixed Income Allocation by Maturity with TBA Cash Offset"]..allocations..name
        Sort List    ${fund_center_maturity_names}

        ${fund_center_maturity_percentage_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?@.data.name=="Fixed Income Allocation by Maturity with TBA Cash Offset"]..allocations..weight.value
        ${fund_center_maturity_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % (value * 100) for value in ${fund_center_maturity_percentage_raw_values}]
        Sort List    ${fund_center_maturity_percentages}

        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${reportcenter_portfolios_list_url}
        ${data_id}    Get Attribute    [id="DataUpdateId"] > option:nth-child(1)    value
        Go To    ${reportcenter_portfolios_list_url}/Detail?portfolioNumber=${portfolio_id}&dataUpdateId=${data_id}&currency=USD

        ${report_center_maturity_names}    Create List
        ${report_center_maturity_percentage_raw_values}   Create List
        ${report_center_maturity_values}    Get Elements    ${reportcenter_maturity_allocation_section_rows.replace("PLACEHOLDER","${portfolio_id}")}

        ${first_group_name_check}   Set Variable    0
        ${second_group_name_check}   Set Variable    0
        ${third_group_name_check}   Set Variable    0
        ${fourth_group_name_check}   Set Variable    0

        ${first_group_value_check}   Set Variable    0
        ${second_group_value_check}   Set Variable    0
        ${third_group_value_check}   Set Variable    0
        ${fourth_group_value_check}   Set Variable    0

        FOR  ${value}  IN  @{report_center_maturity_values}
            ${name}    Get Property    ${value} >> td:nth-child(1)    textContent
            ${rating}    Get Property    ${value} >> td:nth-child(2)    textContent
            IF    $rating != ''
                IF  '${name}' in ['0 - 3 Months', '3 - 6 Months', '6 - 9 Months', '9 - 12 Months']
                    ${first_group_name_check}   Set Variable    1
                    ${first_group_value_check}    Run Keyword And Continue On Failure    Evaluate    ${first_group_value_check} + ${rating}
                ELSE IF  '${name}' in ['1 - 3 Years', '3 - 5 Years']
                    ${second_group_name_check}   Set Variable    1
                    ${second_group_value_check}    Run Keyword And Continue On Failure    Evaluate    ${second_group_value_check} + ${rating}
                ELSE IF  '${name}' in ['5 - 7 Years', '7 - 10 Years']
                    ${third_group_name_check}   Set Variable    1
                    ${third_group_value_check}    Run Keyword And Continue On Failure    Evaluate    ${third_group_value_check} + ${rating}
                ELSE IF  '${name}' in ['10 - 20 Years', '20 - 30 Years']
                    ${fourth_group_name_check}   Set Variable    1
                    ${fourth_group_value_check}    Run Keyword And Continue On Failure    Evaluate    ${fourth_group_value_check} + ${rating}
                END
            END
        END

        Run Keyword If    ${first_group_name_check} == 1    Run Keywords
        ...    Append To List    ${report_center_maturity_names}    0-1 Years    AND
        ...    Append To List    ${report_center_maturity_percentage_raw_values}    ${first_group_value_check}
        Run Keyword If    ${second_group_name_check} == 1    Run Keywords
        ...    Append To List    ${report_center_maturity_names}    1-5 Years    AND
        ...    Append To List    ${report_center_maturity_percentage_raw_values}    ${second_group_value_check}
        Run Keyword If    ${third_group_name_check} == 1    Run Keywords
        ...    Append To List    ${report_center_maturity_names}    5-10 Years    AND
        ...    Append To List    ${report_center_maturity_percentage_raw_values}    ${third_group_value_check}
        Run Keyword If    ${fourth_group_name_check} == 1    Run Keywords
        ...    Append To List    ${report_center_maturity_names}    10+ Years    AND
        ...    Append To List    ${report_center_maturity_percentage_raw_values}    ${fourth_group_value_check}

        ${report_center_maturity_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % float(value) for value in ${report_center_maturity_percentage_raw_values}]
        Sort List    ${report_center_maturity_names}
        Sort List    ${report_center_maturity_percentages}

        Run Keyword And Continue On Failure    Run Keyword If
        ...    $fund_center_maturity_names != $report_center_maturity_names or $fund_center_maturity_percentages != $report_center_maturity_percentages
        ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Maturity Allocation does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Document - Calendar Year Returns
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Calendar Year Returns for a portfolio matches between the fund center and the report center.
    # NOTE: Currently, we do not have a way to validate the Calendar Year Returns for the Market Price datapoint.
    # We are only able to validate the Calendar Year Returns for the Portfolio and Benchmark datapoints.
    # Until we figure out a way to validate https://returnsweb.d.com/, Market Price datapoint validation will have to be manually done.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    40
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_years}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.calendarYearReturns..year
        ${fund_center_benchmark_years}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.benchmarks[0]..benchmarks..calendarYearReturns..year
        IF  ${fund_center_benchmark_years} == []
            ${fund_center_benchmark_years}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.benchmarks[0]..calendarYearReturns..year
        END
        ${fund_center_year_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.calendarYearReturns..value.value
        ${fund_center_year_values}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % value for value in ${fund_center_year_raw_values}]
        ${fund_center_benchmark_year_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.benchmarks[0]..benchmarks..calendarYearReturns..value.value
        IF  ${fund_center_benchmark_year_raw_values} == []
            ${fund_center_benchmark_year_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..data.benchmarks[0]..calendarYearReturns..value.value
        END
        ${fund_center_benchmark_year_values}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % value for value in ${fund_center_benchmark_year_raw_values}]
        Sort List    ${fund_center_years}
        Sort List    ${fund_center_benchmark_years}
        Sort List    ${fund_center_year_values}
        Sort List    ${fund_center_benchmark_year_values}

        ${report_center_benchmarks}    Run Keyword And Continue On Failure    Get Portfolios Benchmarks    ${portfolio_id}
        ${benchmark_ids}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_benchmarks.json()}    $..Number

        ${_}    ${previous_month_year}    Get Previous Month and Year
        ${portfolio_year_for_rc}    Run Keyword And Continue On Failure    Evaluate    ${previous_month_year} - 10
        ${report_center_portfolio_response}    Run Keyword And Continue On Failure    Get Report Center Calendar Year Returns Data    ${portfolio_id}
        ${report_center_portfolio_dict}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_portfolio_response.json()}    $..YearValues
        ${report_center_years}    Run Keyword And Continue On Failure    Evaluate    [i["Year"] for i in $report_center_portfolio_dict[0] if i["Year"] >= ${portfolio_year_for_rc}]
        ${report_center_year_raw_percentage_values}    Run Keyword And Continue On Failure    Evaluate    [i["Value"] for i in $report_center_portfolio_dict[0] if i["Year"] >= ${portfolio_year_for_rc}]
        ${report_center_year_values}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % value for value in ${report_center_year_raw_percentage_values}]

        ${report_center_portfolio_benchmark_response}    Run Keyword And Continue On Failure    Get Report Center Calendar Year Returns Data        ${benchmark_ids}[0]
        ${report_center_portfolio_benchmark_dict}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_portfolio_benchmark_response.json()}    $..YearValues
        ${report_center_years_length}    Get Length    ${report_center_years}
        ${benchmark_year_for_rc}    Run Keyword And Continue On Failure    Evaluate    ${previous_month_year} - ${report_center_years_length}
        ${report_center_benchmark_years}    Run Keyword And Continue On Failure    Evaluate    [i["Year"] for i in $report_center_portfolio_benchmark_dict[0] if i["Year"] >= ${benchmark_year_for_rc}]
        ${report_center_benchmark_year_raw_percentage_values}    Run Keyword And Continue On Failure    Evaluate    [i["Value"] for i in $report_center_portfolio_benchmark_dict[0] if i["Year"] >= ${benchmark_year_for_rc}]
        ${report_center_benchmark_year_values}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % value for value in ${report_center_benchmark_year_raw_percentage_values}]

        Sort List    ${report_center_years}
        Sort List    ${report_center_benchmark_years}
        Sort List    ${report_center_year_values}
        Sort List    ${report_center_benchmark_year_values}

        Run Keyword And Continue On Failure    Run Keyword If
        ...    $fund_center_years != $report_center_years or $fund_center_benchmark_years != $report_center_benchmark_years or $fund_center_year_values != $report_center_year_values or $fund_center_benchmark_year_values != $report_center_benchmark_year_values
        ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Calendar Year Returns does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Annualized Performance - 3 Month
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the annualized performance (3 month) for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    28
    @{failed_portfolios}    Run Keyword And Continue On Failure    Check Annualized Returns For Period    ${portfolio_ids}    annualizedReturn3Month    ThreeMonth
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Annualized performance (3 month) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Annualized Performance - 1 Year
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the annualized performance (1 year) for a portfolio matches between the fund center and the report center.
    # NOTE: Only Portfolio and Benchmark values are being validated here. Market Price values are not being validated yet.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    29
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Annualized Returns For Period    ${portfolio_ids}    annualizedReturn1Year    OneYear
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Annualized performance (1 year) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Annualized Performance - 3 Year
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the annualized performance (3 year) for a portfolio matches between the fund center and the report center.
    # NOTE: Only Portfolio and Benchmark values are being validated here. Market Price values are not being validated yet.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    30
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Annualized Returns For Period    ${portfolio_ids}    annualizedReturn3Year    ThreeYear
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Annualized performance (3 year) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Annualized Performance - 5 Year
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the annualized performance (5 year) for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    31
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Annualized Returns For Period    ${portfolio_ids}    annualizedReturn5Year    FiveYear
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Annualized performance (5 year) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Annualized Performance - 10 Year
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the annualized performance (10 year) for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    32
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Annualized Returns For Period    ${portfolio_ids}    annualizedReturn10Year    TenYear
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Annualized performance (10 year) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Annualized Performance - Since Inception
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the annualized performance (since inception) for a portfolio matches between the fund center and the report center.
    # NOTE: Only Portfolio and Benchmark values are being validated here. Market Price values are not being validated yet.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    33
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Annualized Returns For Period    ${portfolio_ids}    annualizedReturnSincePortfolioInception    SincePortfolioTrueInception
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Annualized performance (since inception) does not match for the following portfolios: ${failed_portfolios}    console=True


Verify FactSheet - Principal Risks
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the investment objective for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    16
    @{failed_portfolios}    Create List
    Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
    Set To Dictionary    ${browser_opt}    args=["--disable-web-security"]
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/us-en/funds

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        Click    ${fund_center_link_portfolio.replace("placeholder", "${portfolio_id}")}
        ${risk_types}    Get Elements    ${fund_center_label_risktypes}
        @{risk_labels}    Create List
        FOR    ${risk_type}    IN    @{risk_types}
             ${fund_center_risk}    Run Keyword And Continue On Failure    Get Text     ${risk_type}
            IF    "China" in $fund_center_risk or "Taiwan" in $fund_center_risk
                Run Keyword And Continue On Failure    Append To List    ${risk_labels}      ${fund_center_risk.split()[0]} investments risk,
            ELSE IF    "Pacific" in $fund_center_risk or "Japan" in $fund_center_risk or "European" in $fund_center_risk or "United Kingdom" in $fund_center_risk
                Run Keyword And Continue On Failure    Append To List    ${risk_labels}      ${fund_center_risk.replace('Market Risk: ','market risk,')}
            ELSE IF    ":" in $fund_center_risk
                Run Keyword And Continue On Failure    Append To List    ${risk_labels}      ${fund_center_risk.strip().lower().replace(":",",")}
            ELSE
                Run Keyword And Continue On Failure    Append To List    ${risk_labels}      ${fund_center_risk.strip().lower()},
            END
        END
        Run Keyword And Continue On Failure    Set List Value    ${risk_labels}    -1    and ${risk_labels[-1].replace(",",".")}
        ${risks_str}    Run Keyword And Continue On Failure    Evaluate    " ".join(str(e) for e in ${risk_labels})
        ${principal_risk_blob}    Run Keyword And Continue On Failure    Catenate    ${principal_risks_preceding}    ${risks_str}     ${principal_risks_succeding}
        Click    ${fund_center_button_funddetailclose}
        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Portfolios Response Data    ${portfolio_id}
        ${report_center_principal_risk}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..PrincipalRiskText
        Log    ----------------------------- ${portfolio_id}------------------------    console=True
        Log    FUND CENTER RISK STMT - ${principal_risk_blob}    console=True
        Log    REPORT CENTER RISK STMT - ${report_center_principal_risk[0]}    console=True     	formatter=repr
        Run Keyword And Continue On Failure    Run Keyword If    str($principal_risk_blob) != str($report_center_principal_risk[0])    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Principal risks does not match for the following portfolios: ${failed_portfolios}    console=True

Verify Characteristics - Number Of Holdings
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the number of holdings for a portfolio matches between the fund center(or chars.dfa) and the report center.
    ${portfolio_ids_with_assetclass}    excelreader.Get Portfolio Ids With AssetClass For Endofquarter Validation    US    17
    Remove From Dictionary       ${context_opt}      userAgent

    FOR  ${item}  IN  @{portfolio_ids_with_assetclass}
        ${portfolio_id}    Set Variable    ${item}[0]
        ${asset_class}     Set Variable    ${item}[1]
        # The portfolios 1409 and 1423 are added in the conditional below as they are real estate ETF funds not found in fixed income api
        # but instead are found in equity char.
        IF  ('${asset_class}' in ['FI', 'BA', 'ETF']) and ('${portfolio_id}' not in ['1409', '1423'])
            ${failed_fi_portfolios}    Run Keyword And Continue On Failure    Check Fixed Income Number Of Holdings    ${portfolio_id}
            # The portfolios 234, 236, and 727 are added in the conditional below as they are BA asset class Fund Of Fund holdings and
            #  have both fixed income and equity holdings on fact sheet.
            IF  '${portfolio_id}' in ['234', '236', '727']
                ${failed_eq_portfolios}    Run Keyword And Continue On Failure    Check Equity Number Of Holdings    ${portfolio_id}
            END
        ELSE
            ${failed_eq_portfolios}    Run Keyword And Continue On Failure    Check Equity Number Of Holdings    ${portfolio_id}
            # TDIF asset class is not added in the list at line 728 because 859, 862 and 863 only have equity holdings on fact sheet
            # while all other TDIF portfolios have both fixed income and equity holdings. Hence added in the conditional below.
            IF  '${portfolio_id}' in ['864', '865', '866', '867', '868', '869', '870', '871', '924', '936']
                ${failed_fi_portfolios}    Run Keyword And Continue On Failure    Check Fixed Income Number Of Holdings    ${portfolio_id}
            END
        END
    END
    Run Keyword If    len(@{failed_fi_portfolios}) != 0    Log    Number of holdings does not match for the following fixed income portfolios: ${failed_fi_portfolios}    console=True
    Run Keyword If    len(@{failed_eq_portfolios}) != 0    Log    Number of holdings does not match for the following equity portfolios: ${failed_eq_portfolios}    console=True


Verify Asset Exposure - Global Equity
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Global Equity asset exposure for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    41
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Asset Class Exposure    ${portfolio_ids}    Equity    Global Equity
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Global Equity asset exposure does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Asset Exposure - Global Fixed Income
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Global Fixed Income asset exposure for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    42
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Asset Class Exposure    ${portfolio_ids}    Global Bonds    Global Fixed Income
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Global Fixed Income asset exposure does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Asset Exposure - Income Risk Management
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the Income Risk Management asset exposure for a portfolio matches between the fund center and the report center.
    @{portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    43
    ${failed_portfolios}    Run Keyword And Continue On Failure    Check Asset Class Exposure    ${portfolio_ids}    Income Risk Management    Income Risk Management
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Income Risk Management asset exposure does not match for the following portfolios: ${failed_portfolios}    console=True


Verify FactSheet - REIT Industries
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the REIT Industries for a portfolio matches between the fund center and the report center.
    ${portfolio_ids}    excelreader.Get Portfolio Ids For Endofquarter Validation    US    59
    @{failed_portfolios}    Create List

    FOR  ${portfolio_id}  IN   @{portfolio_ids}
        ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
        ${fund_center_all_reits}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?@.data.name=="Equity Allocation by REIT"]..allocations

        @{residential_reit_names}    Create List    Single-Family Residential REITs    Multi-Family Residential REITs
        ${residentials_sum}    Run Keyword And Continue On Failure    Evaluate    sum(item["weight"]["value"] for item in ${fund_center_all_reits}[0] if item["name"] in ${residential_reit_names})
        @{special_reit_names}    Create List    Data Center REITs    Self-Storage REITs    Telecom Tower REITs    Other Specialized REITs
        ${specials_sum}    Run Keyword And Continue On Failure    Evaluate    sum(item["weight"]["value"] for item in ${fund_center_all_reits}[0] if item["name"] in ${special_reit_names})

        ${fund_center_all_reits}    Run Keyword And Continue On Failure    Evaluate    [item for item in ${fund_center_all_reits}[0] if (item["name"] not in @{residential_reit_names} and item["name"] not in @{special_reit_names} and item["weight"]["value"] > 0)]
        ${fund_center_reit_names}    Run Keyword And Continue On Failure    Evaluate    [x["name"] for x in ${fund_center_all_reits}]
        ${fund_center_reit_raw_values}    Run Keyword And Continue On Failure    Evaluate    [x["weight"]["value"] for x in ${fund_center_all_reits}]

        Append To List    ${fund_center_reit_names}    Residential REITs
        Append To List    ${fund_center_reit_raw_values}    ${residentials_sum}
        Append To List    ${fund_center_reit_names}    Specialized REITs
        Append To List    ${fund_center_reit_raw_values}    ${specials_sum}

        ${fund_center_reit_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % (value * 100) for value in ${fund_center_reit_raw_values}]

        ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center REIT Industries Data    ${portfolio_id}
        ${report_center_allocations}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Allocations
        ${report_center_all_reits_except_total}    Run Keyword And Continue On Failure    Evaluate    [x for x in ${report_center_allocations}[0] if (x["Key"] not in ["Total REITs"] and x["Weight"] > 0)]
        ${report_center_reit_names}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_all_reits_except_total}    $..Key
        ${report_center_reit_raw_values}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_all_reits_except_total}    $..Weight
        ${report_center_reit_percentages}    Run Keyword And Continue On Failure    Evaluate    ['%.2f%%' % (value) for value in ${report_center_reit_raw_values}]

        Sort List    ${fund_center_reit_names}
        Sort List    ${fund_center_reit_percentages}
        Sort List    ${report_center_reit_names}
        Sort List    ${report_center_reit_percentages}

        Log    \n-----------------Portfolio: ${portfolio_id}-----------------    console=True
        Log    Fund Center REIT Names: \n${fund_center_reit_names}    console=True
        Log    Report Center REIT Names: \n${report_center_reit_names}    console=True
        Log    Fund Center REIT Percentages: \n${fund_center_reit_percentages}    console=True
        Log    Report Center REIT Percentages: \n${report_center_reit_percentages}    console=True

        Run Keyword And Continue On Failure    Run Keyword If
        ...    $fund_center_reit_names != $report_center_reit_names or $fund_center_reit_percentages != $report_center_reit_percentages
        ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    REIT Industries does not match for the following portfolios: ${failed_portfolios}    console=True


Verify Fund Document - Country Holdings
    [Tags]    EndOfQuarter
    [Documentation]    Verify that the top 5 Country Holdings for a portfolio matches between the fund center(or fixed char) and the report center.
    ${portfolio_ids_with_assetclass}    excelreader.Get Portfolio Ids With AssetClass For Endofquarter Validation    US    49
    @{failed_portfolios}    Create List
    New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${chars_fixed_url}

    FOR  ${item}  IN   @{portfolio_ids_with_assetclass}
        ${portfolio_id}    Set Variable    ${item}[0]
        ${asset_class}     Set Variable    ${item}[1]
        Log    \n-----------------Portfolio: ${portfolio_id}-----------------    console=True
        IF  '${asset_class}' not in ['FI']
            ${fund_center_response}    Run Keyword And Continue On Failure    Get Fund Center Response Data    ${portfolio_id}
            ${fund_center_country_holdings}    Run Keyword And Continue On Failure    Get Value From Json    ${fund_center_response.json()}    $..lenses[?(@.data.name == "Equity Allocation by Country")]..subCategories
            ${fund_center_country_data}    Run Keyword And Continue On Failure    Evaluate    {x['name']: '%.2f' % (x['weight']['value'] * 100) for x in (${fund_center_country_holdings}[0] + ${fund_center_country_holdings}[1]) if x['weight']['value'] > 0.01}
            ${fund_center_top_5}    Run Keyword And Continue On Failure    Evaluate    dict(sorted(${fund_center_country_data}.items(), key=lambda x: float(x[1]), reverse=True)[:5])
            Log    Fund Center Top Country Holdings: \n${fund_center_top_5}    console=True
            ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Equity Chars Allocations Data    ${portfolio_id}    8
            ${report_center_country_holdings}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $..Allocations
            ${report_center_country_data}    Run Keyword And Continue On Failure    Evaluate    {x['Description'] : '%.2f' % x['Weight'] for x in ${report_center_country_holdings}[0] if x['Weight'] > 0.01}
            ${report_center_top_5}    Run Keyword And Continue On Failure    Evaluate    dict(sorted(${report_center_country_data}.items(), key=lambda x: float(x[1]), reverse=True)[:5])
            Log    Report Center Top Country Holdings: \n${report_center_top_5}    console=True

            Run Keyword And Continue On Failure    Run Keyword If    $fund_center_top_5 != $report_center_top_5
            ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
        ELSE
            Run Keyword And Continue On Failure    Wait For Elements State    ${fixedchars_button_submit}   visible    30s
            Run Keyword And Continue On Failure    Check Checkbox    ${fixedchars_checkbox_portfolio.replace("PLACEHOLDER", "${portfolio_id}")}
            Run Keyword And Continue On Failure    Click   ${fixedchars_button_submit}
            Run Keyword And Continue On Failure    Select Options By    ${fixedchars_dropdown_sorttype}     value    1
            Run Keyword And Continue On Failure    Wait For Elements State    ${fixedchars_dropdown_filter}   visible    30s
            Run Keyword And Continue On Failure    Select Options By    ${fixedchars_dropdown_filter}     value    7
            Run Keyword And Continue On Failure    Click   ${fixedchars_button_viewcharacteristics}
            Run Keyword And Continue On Failure    Wait For Elements State    b >> text=Total      visible    30s
            ${rows}    Run Keyword And Continue On Failure    Get Elements    ${fixedchars_table_rows}
            ${char_country_holdings}    Create Dictionary
            FOR    ${row}    IN    @{rows}[5:-1]
                ${country}    Get Text    ${row} >> td:first-child
                ${weight}    Get Text    ${row} >> td:nth-child(3)
                Run Keyword If    'Inflation' not in '${country}'    Set To Dictionary    ${char_country_holdings}    ${country}    ${weight.replace('%','')}
            END
            Run Keyword And Continue On Failure    Click   ${fixedchars_button_mainmenu}
            ${char_top_5}    Run Keyword And Continue On Failure    Evaluate    dict(sorted(${char_country_holdings}.items(), key=lambda x: float(x[1]), reverse=True)[:5])
            Log    Fixed Char Top Country Holdings: \n${char_top_5}    console=True
            ${report_center_response}    Run Keyword And Continue On Failure    Get Report Center Country Allocations - Fixed    ${portfolio_id}    7
            ${report_center_country_holdings}    Run Keyword And Continue On Failure    Get Value From Json    ${report_center_response.json()}    $
            ${report_center_country_data}    Run Keyword And Continue On Failure    Evaluate    {x['Key'][0] : '%.2f' % x['Value']['Weight'] for x in ${report_center_country_holdings}[0] if x['Value']['Weight'] > 0.01 and x['Key'][0] != 'Total' and 'Inflation' not in x['Key'][0]}
            ${report_center_top_5}    Run Keyword And Continue On Failure    Evaluate    dict(sorted(${report_center_country_data}.items(), key=lambda x: float(x[1]), reverse=True)[:5])
            Log    Report Center Top Country Holdings: \n${report_center_top_5}    console=True

            Run Keyword And Continue On Failure    Run Keyword If    $char_top_5 != $report_center_top_5
            ...    Run Keywords    Append To List    ${failed_portfolios}    ${portfolio_id}    AND     Fail
        END
    END
    Run Keyword If    len(@{failed_portfolios}) != 0    Log    Top Holdings does not match for the following portfolios: ${failed_portfolios}    console=True
