# This is page object for "dev-lab/qa-test-pages/content-pages/tuning-out-the-noise"


*** Variables ***
${PDFConverterCMSPage_Button_Share}               [data-qa="button-icon-share"].button-icon-teal
${PDFConverterCMSPage_Tab_PublicLinks}            [data-qa="content-page-share-tab-PublicLinks"]
${PDFConverterCMSPage_Text_ShareLink}             [data-qa="content-page-share-link-url"]
${PDFConverterCMSPage_Tab_AdditionalLinks}        [data-qa="content-page-share-tab-AdditionalLinks"]
${PDFConverterCMSPage_Tab_XLink}                  "External Link"
${PDFConverterCMSPage_Button_Download}            .content-page-header >> [data-qa="button-icon-download-pdf-convertor"]
${PDFConverterCMSPage_Button_ModalClose}          [data-qa="share-modal-close"]
${PDFConverterCMSPage_Image_PPTThumbnail}         [data-qa="content-page-module-powerpoint-thumbnail-img"]
${PDFConverterCMSPage_Button_PPTDownloadIcon}     [href*=ppt][data-qa="button-icon-download-url"]

*** Keywords ***


Verify Share Modal
    [Documentation]  Verify shareable links exist w/o xlink.
    Click       ${PDFConverterCMSPage_Button_Share}
    Run Keyword And Continue On Failure     Wait For Elements State     ${PDFConverterCMSPage_Tab_PublicLinks}
    Run Keyword And Continue On Failure     Get Text        ${PDFConverterCMSPage_Text_ShareLink}         then        len(value) != 0
    Click       ${PDFConverterCMSPage_Tab_AdditionalLinks}
    Run Keyword And Continue On Failure     Get Element States      ${PDFConverterCMSPage_Tab_XLink}     contains      detached
    Run Keyword And Continue On Failure     Take Screenshot         fullPage=True
    Click       ${PDFConverterCMSPage_Button_ModalClose}

Verify PDF Generation and Download
    ${file_obj}     Download Given Document            ${PDFConverterCMSPage_Button_Download}
    Should Match Regexp 	${file_obj.suggestedFilename}	    .pdf$


Download Powerpoint
    ${file_obj_image}     Download Given Document            ${PDFConverterCMSPage_Image_PPTThumbnail}
    ${file_obj_button}     Download Given Document            ${PDFConverterCMSPage_Button_PPTDownloadIcon}
    Should Be Equal    	${file_obj_button}[suggestedFilename]	    ${file_obj_image}[suggestedFilename]
