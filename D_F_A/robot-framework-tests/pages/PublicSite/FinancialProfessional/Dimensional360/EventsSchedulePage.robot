# This is page object for "us-en/financial-professionals/d-360/events-schedule"

*** Variables ***
${EventsSchedulePage_Container_EventsTableHeader}           [class*="_dDataGridHeader"][class*="_dDataGridRow_"]
${EventsSchedulePage_Container_EventsTableRow}              :not([class*="_dDataGridHeader"])[class*="_dDataGridRow_"]
${EventsSchedulePage_Text_EventsTableTitle}                 .events-table-title-text
${EventsSchedulePage_Text_NoEventsMessage}                  .dDataGridMessage
${EventsSchedulePage_Link_DownloadBrochure}                 .primary-standalone-download
@{EventsSchedulePage_Text_EventsTableColumnHeaderValues}    DATE    EVENT    LOCATION    CE AVAILABLE
${EventsSchedulePage_Container_EventsTableCell}             :not([class*="_dDataGridCellHeader"])[class*="_dDataGridCell_"],[class*="dDataGridCellUnbolded"]
${EventsSchedulePage_Container_EventsTableCellValue}        [class*="_dDataGridCellValue_"]
${EventsSchedulePage_Container_EventTooltip}                [data-qa="d-tooltip-information-tooltip"]
${EventsSchedulePage_Icon_EventLittlei}                     [data-qa="d-icon-information-expressive"]
${EventsSchedulePage_Text_EventTooltip}                     [data-qa="d-tooltip-window-information-tooltip"]
${EventsSchedulePage_Icon_EventCEState}                     [data-qa="image-check-clear"]
${EventsSchedulePage_Button_EventsTablePageButtons}         [data-qa="d-data-paginator-button"]
${EventsSchedulePage_Button_EventsTablePageNumber}          :not([data-a-name*='Indicator'])${EventsSchedulePage_Button_EventsTablePageButtons}
${EventsSchedulePage_Button_EventsTablePageArrow}           [data-a-name*='Placeholder_Text']

*** Keywords ***
Check Events Table Title, No Event Message and Download Brochure Link
    ${pages}    Get Elements    ${EventsSchedulePage_Button_EventsTablePageNumber}
    ${page_count}    Get Length    ${pages}
    ${rows}    Get Elements    ${EventsSchedulePage_Container_EventsTableRow}
    ${row_count}    Get Length    ${rows}
    Run Keywords    Set Test Variable    ${pages}    AND    Set Test Variable    ${page_count}
    ...    AND    Set Test Variable    ${rows}    AND    Set Test Variable    ${row_count}

    ${current_month}   Evaluate   time.strftime("%b")
    ${current_year}    Evaluate    time.strftime("%Y")

    Run Keyword And Continue On Failure    Get Style    ${EventsSchedulePage_Text_EventsTableTitle}    color    equals    ${AlmostBlack}
    Run Keyword And Continue On Failure    Get Classes    ${EventsSchedulePage_Text_EventsTableTitle}    contains    t-body-xl

    IF  ${row_count} == 0
        Run Keyword And Continue On Failure    Get Text    ${EventsSchedulePage_Text_EventsTableTitle}    contains    No Events Available
        Run Keyword And Continue On Failure    Check No Event Message If Present
    ELSE
        Run Keyword And Continue On Failure    Get Text    ${EventsSchedulePage_Text_EventsTableTitle}    validate    ("${current_month}" and "${current_year}" in value)
        Run Keyword And Continue On Failure    Get Element States    ${EventsSchedulePage_Text_NoEventsMessage}    contains    detached
        Run Keyword And Continue On Failure    Click    ${pages}[${page_count - 1}]
        Run Keyword And Continue On Failure    Check No Event Message If Present
        Run Keyword And Continue On Failure    Click    ${pages}[0]
    END

    Run Keyword And Continue On Failure    Get Text    ${EventsSchedulePage_Link_DownloadBrochure}    equals    DOWNLOAD ${current_year} EVENTS BROCHURE
    Run Keyword And Continue On Failure    Get Style    ${EventsSchedulePage_Link_DownloadBrochure}    color    equals    ${Teal900}
    Run Keyword And Continue On Failure    Get Attribute    ${EventsSchedulePage_Link_DownloadBrochure}    href    contains    download
    ${file_obj}    Download Given Document    ${EventsSchedulePage_Link_DownloadBrochure}
    Run Keyword And Continue On Failure    Should Contain    ${file_obj.suggestedFilename}    .pdf     ignore_case=True


Check No Event Message If Present
    ${message_states}    Run Keyword And Continue On Failure    Get Element States    ${EventsSchedulePage_Text_NoEventsMessage}
    IF  "visible" in "${message_states}"
        Run Keyword And Continue On Failure    Get Text    ${EventsSchedulePage_Text_NoEventsMessage}    contains    events will be posted soon
        Run Keyword And Continue On Failure    Get Style    ${EventsSchedulePage_Text_NoEventsMessage}    color    equals    ${AlmostBlack}
        Run Keyword And Continue On Failure    Get Style    ${EventsSchedulePage_Text_NoEventsMessage}    background-color    equals    ${WarmGray06}
    END

Check Events Table Grid Values
    ${labels}    Get Elements    ${EventsSchedulePage_Container_EventsTableHeader} >> span
    Run Keyword And Continue On Failure    Get Style    ${EventsSchedulePage_Container_EventsTableHeader}    background-color    equals    ${CoolGray900}
    FOR    ${index}    ${label}    IN ENUMERATE    @{labels}
        Run Keyword And Continue On Failure    Get Text    ${label}    equals    ${EventsSchedulePage_Text_EventsTableColumnHeaderValues}[${index}]
        Run Keyword And Continue On Failure    Get Style    ${label}    color    equals    ${White}
    END

    IF  ${row_count} != 0
        FOR    ${row}    IN    @{rows}
            ${cells}    Get Elements    ${row} >> ${EventsSchedulePage_Container_EventsTableCell}
            FOR    ${index}    ${cell}    IN ENUMERATE    @{cells}
                IF  ${index} != 3
                    ${cell_text}    Get Text    ${cell}
                    Run Keyword And Continue On Failure    Should Match Regexp    ${cell_text}    ^[A-Za-z. ]+(\\d{1,2}(–\\d{1,2})?)?$
                    Run Keyword And Continue On Failure    Get Style    ${cell} >> ${EventsSchedulePage_Container_EventsTableCellValue}    color    equals    ${CoolGray1200}
                    Run Keyword And Continue On Failure    Run Keyword If    (${index} == 2 and '${cell_text}' == 'Virtual')    Get Classes    ${cell} >> span    validate    any("italic" in v for v in value)
                    IF  ${index} == 1
                        ${tooltip_state}    Run Keyword And Continue On Failure    Get Element States    ${cell} >> ${EventsSchedulePage_Container_EventTooltip}
                        IF  'visible' in ${tooltip_state}
                            Run Keyword And Continue On Failure    Get Style    ${cell} >> ${EventsSchedulePage_Icon_EventLittlei}    color    equals    ${CoolGray800}
                            Run Keyword And Continue On Failure    Hover    ${cell} >> ${EventsSchedulePage_Container_EventTooltip}
                            Run Keyword And Continue On Failure    Get Element States    ${EventsSchedulePage_Text_EventTooltip}    validate    visible
                            Run Keyword And Continue On Failure    Get Text    ${EventsSchedulePage_Text_EventTooltip}    !=    ${EMPTY}
                            Run Keyword And Continue On Failure    Get Style    ${cell} >> ${EventsSchedulePage_Icon_EventLittlei}    color    equals    ${Teal900}
                            Run Keyword And Continue On Failure    Mouse Move    0    0
                            Run Keyword And Continue On Failure    Get Element States    ${EventsSchedulePage_Text_EventTooltip}    validate    hidden
                        END
                    END
                ELSE
                    ${ce_state}    Run Keyword And Continue On Failure    Get Element States    ${cell} >> ${EventsSchedulePage_Icon_EventCEState}
                    Run Keyword And Continue On Failure    Run Keyword If    'visible' in ${ce_state}    Run Keywords    Get Attribute    ${cell} >> ${EventsSchedulePage_Icon_EventCEState} > path    d    matches    ^m*.*-.*z$
                    ...    AND    Get Style    ${cell} >> ${EventsSchedulePage_Icon_EventCEState} > path    fill    equals    ${CoolGray1200}
                END
            END
        END
    END


Check Events Table Pagination
    IF    ${page_count} == 1
        Run Keyword And Continue On Failure    Check Arrow States    disabled    disabled
        Run Keyword And Continue On Failure    Check Page States    ${pages}[0]    equals
        Run Keyword And Continue On Failure    Check GA Attributes
    ELSE IF  ${page_count} == 2
        Run Keyword And Continue On Failure    Check Arrow States    disabled    enabled
        Run Keyword And Continue On Failure    Run Keywords    Check Page States    ${pages}[0]    equals    AND   Check Page States    ${pages}[1]    inequal
        Run Keyword And Continue On Failure    Click    ${pages}[1]
        Run Keyword And Continue On Failure    Check Arrow States    enabled    disabled
        Run Keyword And Continue On Failure    Run Keywords    Check Page States    ${pages}[0]    inequal    AND    Check Page States    ${pages}[1]    equals
        Run Keyword And Continue On Failure    Check GA Attributes
    ELSE
        Run Keyword And Continue On Failure    Check Arrow States    disabled    enabled
        Run Keyword And Continue On Failure    Run Keywords    Check Page States    ${pages}[0]    equals    AND    Check Page States    ${pages}[1]    inequal
        Run Keyword And Continue On Failure    Click    ${pages}[${page_count - 1}]
        Run Keyword And Continue On Failure    Check Arrow States    enabled    disabled
        Run Keyword And Continue On Failure    Run Keywords    Check Page States    ${pages}[${page_count - 1}]    equals    AND    Check Page States    ${pages}[0]    inequal
        Run Keyword And Continue On Failure    Click    ${pages}[${page_count - 2}]
        Run Keyword And Continue On Failure    Check Arrow States    enabled    enabled
        Run Keyword And Continue On Failure    Run Keywords    Check Page States    ${pages}[${page_count - 2}]    equals    AND    Check Page States    ${pages}[${page_count - 1}]    inequal
        Run Keyword And Continue On Failure    Check GA Attributes
    END


Check Page States
    [Arguments]    ${page}    ${assertion}
    Run Keyword And Continue On Failure    Get Style    ${page} >> span    color    ${assertion}    ${Teal900}
    Run Keyword And Continue On Failure    Get Style    ${page}    background-color    ${assertion}    ${WarmGray05}


Check Arrow States
    [Arguments]    ${left_arrow_state}    ${right_arrow_state}
    Run Keyword And Continue On Failure    Get Element States    ${EventsSchedulePage_Button_EventsTablePageArrow.replace("Placeholder_Text","Left")}   contains    ${left_arrow_state}
    Run Keyword And Continue On Failure    Get Element States    ${EventsSchedulePage_Button_EventsTablePageArrow.replace("Placeholder_Text","Right")}    contains    ${right_arrow_state}


Check GA Attributes
    ${pagination_buttons}    Get Elements    ${EventsSchedulePage_Button_EventsTablePageButtons}
    FOR    ${button}    IN    @{pagination_buttons}
        Run Keyword And Continue On Failure    Get Attribute    ${button}    data-a-evt    equals    Link Click
        Run Keyword And Continue On Failure    Get Attribute    ${button}    data-a-comp    equals    Events Table
    END
    Run Keyword And Continue On Failure    Get Attribute    ${EventsSchedulePage_Link_DownloadBrochure}    data-a-evt    equals    Download
    Run Keyword And Continue On Failure    Get Attribute    ${EventsSchedulePage_Link_DownloadBrochure}    data-a-comp    equals    Events Table