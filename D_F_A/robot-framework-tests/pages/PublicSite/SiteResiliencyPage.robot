*** Variables ***
${SiteResiliency_Link_Investments}                       "Investments"
${SiteResiliency_FundCenterField_AsOfDate}               .tools-fund-listing-headers-nav>div:nth-child(2)
${SiteResiliency_Link_RegulatoryDocuments}               a[href*="regulatory"]
${SiteResiliency_Header_CountryRegulatoryDocuments}      .grid>>h2
${SiteResiliency_Links_CountryRegulatoryDocuments}       .content-page-section >> .rtf-container >> p >> a

*** Keywords ***
Check Funds Info For Countries
    ${countries_investments}    Get Elements        ${SiteResiliency_Link_Investments}
    FOR    ${country_investment}    IN    @{countries_investments}
        Click        ${country_investment}
        ${date}    Get Text    ${SiteResiliency_FundCenterField_AsOfDate}
        ${country}      Return Country Code
        ${days_diff}    Get Days Difference    ${date[-10:]}    format=${yaml_data['${country}']['info_dateformat']}
        Run Keyword And Continue On Failure     Should Be True    $days_diff <= 4    Please Check ${date} for ${yaml_data['${country}']['country_name']}
        Go Back
    END

Check Regulatory Documents and Disclosures
    ${reg_docs}    Get Elements        ${SiteResiliency_Link_RegulatoryDocuments}
    Log     \n ======================CHECKING REG DOCUMENTS==============================        console=True
    FOR    ${reg_doc}    IN    @{reg_docs}
        Run Keyword And Continue On Failure    Click    ${reg_doc}
        ${country}    Return Country Code
        Run Keyword And Continue On Failure    Wait For Condition    Text    ${SiteResiliency_Header_CountryRegulatoryDocuments}     contains     Regulatory and Other Important Documents and Disclosures
        ${links}   Run Keyword And Continue On Failure    Get Element Count    ${SiteResiliency_Links_CountryRegulatoryDocuments}     >    0
        Log    ${country} has ${links} regulatory documents and disclosures    console=True
        Go Back
    END


Return Country Code
    ${fund_center_url}    Get Url
    ${country}    Evaluate    re.search(f'(?<=com\/).*(?=-)','${fund_center_url}').group(0).upper()
    ${country}    Set Variable If    '${country}' == 'GB'    UK    ${country}
    RETURN    ${country}
