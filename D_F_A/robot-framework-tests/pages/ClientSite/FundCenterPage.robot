*** Variables ***

${FundCenterPage_Button_BuildNewModel}    [data-qa="build-new-model-button"]
${FundCenterPage_Tab_Models}              [data-qa="tab-item-models"]
${FundCenterPage_Tab_UMAS}                [data-qa="tab-item-umas"]
${FundCenterPage_Label_ModelsRC}          [data-qa="model-listing-filter-risk_categorization"]
${FundCenterPage_Button_BuildNewUMA}      [data-qa="build-new-sma-button"]
${FundCenterPage_Button_AcceptTerms}      [aria-label="Accept"]
${FundCenterPage_Link_FundNames}          [data-qa^="fund-link"]
${FundCenterPage_Link_TitleDocs}          [data-qa="documents-lens"] >> a:not([aria-label$="View Documents for All Funds"],[aria-label$="Definitions of Terms"])
${FundCenterPage_Link_LinkDocs}           [data-qa="documents-lens"] >> a[href*="d.com"]
${FundCenterPage_Label_PortfolioID}       [data-qa="summary-section"] >> [data-qa="lens"] >> div
${FundCenterPage_Button_CloseDialog}      [data-qa="close-compare-dialog-btn"]
${Random_NoOf_Portfolios}                 ${5}
${Random_NoOf_Documents}                  ${3}

*** Keywords ***

Ensure All Investments Showup
    Run Keyword And Ignore Error     Click       ${FundCenterPage_Button_AcceptTerms}
    Run Keyword And Continue On Failure     Wait For Elements State         ${FundCenterPage_Button_BuildNewModel}       enabled        timeout=60
    Run Keyword And Continue On Failure     Get Element Count    ${FundCenterPage_Link_FundNames}     >    1
    Click       ${FundCenterPage_Tab_Models}
    Run Keyword And Continue On Failure     Wait For Elements State         ${FundCenterPage_Label_ModelsRC}    visible
    Click       ${FundCenterPage_Tab_UMAS}
    Wait For Elements State         ${FundCenterPage_Button_BuildNewUMA}         enabled
    Take Screenshot             fullPage=True


Check Fund Centre Documents
    Run Keyword And Ignore Error     Click       ${FundCenterPage_Button_AcceptTerms}
    Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
    ${funds}        Get Elements       ${FundCenterPage_Link_FundNames}
    ${funds_sample}     Evaluate       random.sample(${funds}, ${Random_NoOf_Portfolios})

    FOR    ${fund}   IN      @{funds_sample}
            Run Keyword And Continue On Failure    Click       ${fund}
            ${fund_id}    Get Property    ${FundCenterPage_Label_PortfolioID}    innerText
            Log    ${EMPTY}    console=True
            Log    ${fund_id}    console=True
            Log    =====================================================================================================================================================    console=True
            Run Keyword And Continue On Failure    Check Document Links
            Run Keyword And Continue On Failure    Click       ${FundCenterPage_Button_CloseDialog}
    END


Check Client Site Fund Documents
    [Arguments]    ${country}
    Run Keyword And Ignore Error    Click    ${FundCenterPage_Button_AcceptTerms}

    ${portfolio_data}    excelreader.return portfolios    ${country}
    FOR  ${portfolio}  IN  @{portfolio_data}

        Log    ${EMPTY}    console=True
        Log    ${portfolio['portfolio_id']}    console=True
        Log    =====================================================================================================================================================    console=True

        Run Keyword And Continue On Failure    Click    ${FundCenterPage_Link_FundNames} >> '${portfolio['portfolio_name']}'
        Run Keyword If    'REGRESSION' not in @{OPTIONS.include}    Run Keyword And Continue On Failure    Check Document Links
        Run Keyword And Continue On Failure    Check Document Titles    ${portfolio}
        Run Keyword And Continue On Failure    Click    ${FundCenterPage_Button_CloseDialog}
    END


Check Document Titles
    [Arguments]        ${portfolio}
    [Documentation]    This check will not consider "View Documents for All Funds" and "Definitions of Terms" in the document count validation.
    ${documents}    Get Elements    ${FundCenterPage_Link_TitleDocs}
    ${document_titles}    Create List

    FOR  ${document}  IN  @{documents}
        ${doc_title}    Get Property    ${document}    innerText
        Run Keyword And Continue On Failure    Append To List    ${document_titles}    ${doc_title}
    END
    Log    Expected Count: ${{len(@{portfolio['client_docs']})}} -> Actual Count: ${{len(@{document_titles})}}     console=True
    Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${document_titles}    ${portfolio['client_docs']}    ignore_order=True


Check Document Links
    [Documentation]    This check will not consider any csv links or the "View Documents for All Funds" and "Definitions of Terms" links for validation.
    ${links}    Run Keyword And Continue On Failure    Get Elements    ${FundCenterPage_Link_LinkDocs}
    IF    "Random" in "${TEST_NAME}"
        @{links_sample}    Evaluate       random.sample(${links}, min($Random_NoOf_Documents, len($links)))
    ELSE
        @{links_sample}    Set Variable    ${links}
    END
    FOR  ${link}  IN  @{links_sample}
        ${attr}    Run Keyword And Continue On Failure    Get Attribute Names    ${link}
        ${title}   Run Keyword And Continue On Failure    Get Property    ${link}    innerText
        IF    "download" in ${attr}
                Log    ${title}     console=True
                Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True
                ${file_obj}     Run Keyword And Continue On Failure    Download Given Document    ${link}
                Run Keyword And Continue On Failure    Should Be True    any(item in '${file_obj.suggestedFilename}' for item in ['.pdf', '.zip'])
        END
    END
