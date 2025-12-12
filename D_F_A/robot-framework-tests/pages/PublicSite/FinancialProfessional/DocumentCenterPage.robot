*** Keywords ***

Check Fund Documents
    [Arguments]     ${country}
    [Documentation]     Check if fund documents names and total on page match our config
    ${portfolio_data}       excelreader.return portfolios         ${country}
    Set To Dictionary        ${context_opt}       userAgent=dfa_newrelic-synthetic
    Run Keyword If      '${country}'=='AU'     New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${PUBLIC_SITE_URL}/${yaml_data['${country}']['country_language']}/document-centre
    ...     ELSE IF       '${country}'=='UK'        New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${PUBLIC_SITE_URL}/legal-document-centre-for-investors
    ...     ELSE        New Browser Context and Page           browser_options=${browser_opt}      context_options=${context_opt}      url=${PUBLIC_SITE_URL}/${yaml_data['${country}']['country_language']}/document-center

    Log    ${EMPTY}    console=True
    Log    *** ${country} ***    console=True

    FOR     ${portfolio}        IN       @{portfolio_data}
            Run Keyword And Continue On Failure     Wait For Elements State         "${portfolio['portfolio_id']}"

            Log    ${EMPTY}    console=True
            Log    ${portfolio['portfolio_id']}    console=True
            Log    =====================================================================================================================================================    console=True

            ${documents}        Get Elements      "${portfolio['portfolio_id']}" >> ../.. >> li
            ${document_titles}  	    Create List
            FOR    ${document}    IN    @{documents}
                ${title}    Get Text    ${document} >> .item-title
                Run Keyword And Continue On Failure    Append To List    ${document_titles}    ${title}
            END

            Log    Expected Count: ${{len(@{portfolio['public_docs']})}} -> Actual Count: ${{len(@{document_titles})}}     console=True
            Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True

            Run Keyword And Continue On Failure     Lists Should Be Equal       ${document_titles}        ${portfolio['public_docs']}       ignore_order=True

    END


Check Fund Assets
    [Arguments]    ${country}
    ${asset_data}    excelreader.Get Portfolio Documents    ${country}
    ${portfolio_ids}    Get Dictionary Keys    ${asset_data}
    @{failed_funds}    Create List
    Log    ${yaml_data['${country}']['country_name']}    console=True
    Log    ====================================================================================    console=True

    FOR  ${portfolio_id}  IN  @{portfolio_ids}
        ${portfolio_data}    Set Variable    ${asset_data}[${portfolio_id}]
        ${doc_names}    Get Dictionary Keys    ${portfolio_data}[Documents]
        ${doc_assets}    Get Dictionary Values    ${portfolio_data}[Documents]

        ${ui_doc_assets}    Create List
        Set To Dictionary    ${context_opt}    userAgent=dfa_newrelic-synthetic
        New Browser Context and Page    browser_options=${browser_opt}    context_options=${context_opt}    url=${PUBLIC_SITE_URL}/${yaml_data['${country}']['country_language']}/document-center

        FOR  ${doc_name}  IN  @{doc_names}
            ${linkval}    Run Keyword And Continue On Failure    Get Attribute    "${portfolio_data}[Portfolio Name]" >> ../.. >> li >> .item-title >> "${doc_name}" >> ../.. >> a   href
            ${asset_id}    Run Keyword And Continue On Failure    Get Regexp Matches    ${linkval}    /chmedia/(\\d+)/source    1    flags=IGNORECASE
            ${asset_id}    Run Keyword And Continue On Failure    Convert To Integer    ${asset_id}[0]
            Run Keyword And Continue On Failure    Append To List    ${ui_doc_assets}    ${asset_id}
        END

        Log    Portfolio ID: ${portfolio_id}    console=True
        Log    Portfolio Name: ${portfolio_data}[Portfolio Name]    console=True
        Log    Documents: ${doc_names}    console=True
        Log    Expected Asset IDs: ${doc_assets}    console=True
        Log    Actual Asset IDs: ${ui_doc_assets}    console=True
        Log    ------------------------------------------------------------------------------------    console=True

        Run Keyword And Continue On Failure    Run Keyword If    $doc_assets != $ui_doc_assets    Run Keywords    Append To List    ${failed_funds}    ${country}:${portfolio_id}    AND    Fail
    END
    RETURN    @{failed_funds}