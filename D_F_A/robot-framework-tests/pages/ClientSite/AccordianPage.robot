# This is page object for
# "dev-lab/qa-test-pages/test-accordion-page" which containts accordian and secondary asset component


*** Variables ***

${AccordianPage_Button_DropdownItems}           [data-qa="accordion-page-item-button"]
${AccordianPage_Div_Metadata}                   [data-qa="content-page-metadata"]
${AccordianPage_List_ApprovedCountries}         [data-qa="content-page-approved-country"]
${AccordianPage_Button_MetadataUse}             [data-qa="content-page-metadata-access-type"]
${AccordianPage_Button_Download}                a[data-qa="button-icon-download-url"][class*="teal"]
${AccordianPage_Button_PDFDownload}             a[href*="volatility"][data-qa="button-icon-download-url"]
${AccordianPage_Link_PDFView}                   a[href*="volatility"][data-qa="content-page-view-pdf-link"]
${AccordianPage_Image_PDFThumbnail}             [data-a-name="Low Volatility Strategies"]>img
${AccordianPage_Label_SecondaryAssetContainer}  .content-page-secondary-assets-list-label
${AccordianPage_Div_SecondaryAssets}            .content-page-secondary-assets
${AccordianPage_Link_SecondaryAsset}            .content-page-secondary-assets-link
${AccordianPage_Title_SecondaryAsset}           .content-page-secondary-assets-title
${AccordianPage_Desc_SecondaryAsset}            .content-page-secondary-assets-desc
${AccordianPage_DownloadIcon_SecondaryAsset}    [data-qa="button-icon-download-url"]

*** Keywords ***

Expand-Collapse Accordian
    ${accordian_items}      Run Keyword And Continue On Failure     Get Elements     ${AccordianPage_Button_DropdownItems}
    #${accordian_item}      Evaluate       random.choice(${accordian_items})
    FOR    ${accordian_item}    IN    @{accordian_items}
            Run Keyword And Continue On Failure     Get Attribute    ${accordian_item}       aria-expanded    ==     false
            Click       ${accordian_item}
            Run Keyword And Continue On Failure     Wait For Condition    Attribute    ${accordian_item}      aria-expanded      ==     true
    END


Check Metadata Section
    Run Keyword And Continue On Failure     Get Element States    ${AccordianPage_Div_Metadata}    then    bool(value & visible)
    Run Keyword And Continue On Failure     Get Element Count    ${AccordianPage_List_ApprovedCountries}    >=    1
    Run Keyword And Continue On Failure     Get Attribute       ${AccordianPage_Button_MetadataUse}       data-event    !=     true
    Run Keyword If      '${browserlib}'=='firefox'     Click       ${AccordianPage_Button_MetadataUse}
    ...     ELSE        Hover       ${AccordianPage_Button_MetadataUse}
    Get Attribute       ${AccordianPage_Button_MetadataUse}       data-event    ==     true

Open and Download PDF
    Run Keyword And Continue On Failure     Get Attribute    ${AccordianPage_Button_PDFDownload}    data-a-comp    ==    Article Header
    Run Keyword And Continue On Failure     Get Attribute    ${AccordianPage_Button_PDFDownload}    data-e-evt    ==    Download
    ${file_obj}     Run Keyword And Continue On Failure     Download Given Document            ${AccordianPage_Button_PDFDownload}
    Run Keyword And Continue On Failure     Should Contain    ${file_obj.suggestedFilename}    .pdf     ignore_case=True
    ${path_link}     Run Keyword And Continue On Failure     Get Property           ${AccordianPage_Link_PDFView}        href
    Run Keyword And Continue On Failure     Load-As-Web-Service         ${path_link}
    ${path_image}     Run Keyword And Continue On Failure     Get Property           ${AccordianPage_Image_PDFThumbnail}       src
    Load-As-Web-Service         ${path_image}

Check Individual Secondary Assets
    Run Keyword And Continue On Failure    Get Text    ${AccordianPage_Label_SecondaryAssetContainer}     contains    ${QA_Test_Characterset}
    Run Keyword And Continue On Failure    Get Classes    ${AccordianPage_Label_SecondaryAssetContainer}>h3    validate    any("almost-black" in v for v in value)
    ${secondary_assets}    Run Keyword And Continue On Failure    Get Elements    ${AccordianPage_Div_SecondaryAssets}
    FOR    ${index}    ${asset}    IN ENUMERATE     @{secondary_assets}
        Run Keyword And Continue On Failure   Get Style    ${asset} >> ${AccordianPage_Link_SecondaryAsset} > a     color     ==    ${TEAL02}
        Run Keyword And Continue On Failure   Check Navigation To Valid Content    ${asset} >> ${AccordianPage_Link_SecondaryAsset} > a
        IF    ${index} == 1
            Run Keyword And Continue On Failure   Get Style    ${asset} >> ${AccordianPage_Title_SecondaryAsset}     font-size    ==    18px
            Run Keyword And Continue On Failure   Get Text     ${asset} >> ${AccordianPage_Title_SecondaryAsset}    not contains     ${QA_Test_Characterset}
            Run Keyword And Continue On Failure   Get Text     ${asset} >> ${AccordianPage_Desc_SecondaryAsset}     contains    ${QA_Test_Characterset}
        ELSE IF    ${index} == 2
            Run Keyword And Continue On Failure   Get Text     ${asset} >> ${AccordianPage_Link_SecondaryAsset} > a   not contains     Brochure
            Run Keyword And Continue On Failure     Get Attribute    ${asset} >> ${AccordianPage_DownloadIcon_SecondaryAsset}     data-a-comp    ==   Supporting Materials
            Run Keyword And Continue On Failure     Get Attribute    ${asset} >> ${AccordianPage_DownloadIcon_SecondaryAsset}    data-e-evt    ==    Download
            ${file_obj}     Run Keyword And Continue On Failure     Download Given Document            ${asset} >> ${AccordianPage_DownloadIcon_SecondaryAsset}
            Run Keyword And Continue On Failure     Should Contain    ${file_obj.suggestedFilename}    .zip     ignore_case=True
        ELSE
            Run Keyword And Continue On Failure   Get Text     ${asset} >> ${AccordianPage_Link_SecondaryAsset} > a   !=     ${EMPTY}
            Run Keyword And Continue On Failure   Get Text     ${asset} >> ${AccordianPage_Desc_SecondaryAsset}    !=     ${EMPTY}
        END
    END