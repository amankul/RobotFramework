

*** Variables ***
${AllFundsPage_List_Navs}           .tools-fund-listing-table-col-nav
${AllFundsPage_Link_FundNames}      .tools-fund-listing-table-col-fund-name-public>a
${AllFundsPage_Label_FundID}        .tools-lens-header-title-eyebrow
${AllFundsPage_Link_Documents}      a:not([href="/document-center"]).tools-lens-documents-list-row-link
${Random_NoOf_Portfolios}           ${3}


*** Keywords ***

Check Portfolio Name & NAVs
    [Documentation]     Get all navs listed on all funds page
    Run Keyword And Continue On Failure     Wait For Elements State     "Portfolio Name"        stable
    Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
    ${navs}    Get Element Count     ${AllFundsPage_List_Navs}        >        50
    Log        Total # of funds = ${navs-2}     console=True


Verify Fund Documents Load
    [Documentation]     Check whether fund docs load
    ${funds}        Get Elements       ${AllFundsPage_Link_FundNames}
    ${funds_sample}     Evaluate       random.sample(${funds}, ${Random_NoOf_Portfolios})
    Log    ${EMPTY}    console=True
    Log    =====================================================================================================================================================    console=True

    FOR    ${fund}      IN      @{funds_sample}
        Click       ${fund}
        ${fund_id}    Get Property    ${AllFundsPage_Label_FundID}    innerText
        Log    ${EMPTY}    console=True
        Log    ${fund_id}    console=True
        Log    =====================================================================================================================================================    console=True
        Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
        ${docs}     Get Elements       ${AllFundsPage_Link_Documents}
        FOR     ${doc}    IN      @{docs}
            ${doc_title}      Get Property     ${doc}      innerText
            ${path}     Evaluate JavaScript     ${doc}      (element) => element.href
            Log    ${doc_title} -> ${path}    console=True
            Log    -----------------------------------------------------------------------------------------------------------------------------------------------------    console=True
            Run Keyword And Continue On Failure     Load-As-Web-Service        ${path}    testOnly=true
        END
        Click    [aria-label="Close Compare Dialog"]
    END
