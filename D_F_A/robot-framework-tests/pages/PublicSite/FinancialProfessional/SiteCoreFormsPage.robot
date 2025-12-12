*** Variables ***

${SiteCoreFormsPage_Text_FullName}             [data-sc-field-name="Full Name"]
${SiteCoreFormsPage_Text_FirstName}            [data-sc-field-name="First Name"]
${SiteCoreFormsPage_Text_LastName}             [data-sc-field-name="Last Name"]
${SiteCoreFormsPage_Text_FirmName}             [data-sc-field-name="Firm Name"]
${SiteCoreFormsPage_Text_WorkEmail}            [data-sc-field-name="Work Email"], [data-sc-field-name="Email"]
${SiteCoreFormsPage_Text_WorkPhone}            [data-sc-field-name="Work Phone"], [data-sc-field-name="Phone"]
${SiteCoreFormsPage_Text_Message}              [data-sc-field-name="Message"],[data-sc-field-name="Multiple-Line Text"], [data-sc-field-name="Please provide any additional detail that you think is relevant"]
${SiteCoreFormsPage_Label_ValidationErrors}    .field-validation-error
${SiteCoreFormsPage_Button_FormSubmit}         [type="submit"]
${SiteCoreFormsPage_Select_Required1}          [data-select2-id="1"]
${SiteCoreFormsPage_Select_Required2}          [data-select2-id="3"]
${SiteCoreFormsPage_Select_Required3}          [data-select2-id="7"]
${SiteCoreFormsPage_Option_Yes}                [id*="-Yes"]
${SiteCoreFormsPage_Option_Delete}             [id*="-Delete"]
${SiteCoreFormsPage_Checkbox_Required1}        [value="Via email or phone"]
${SiteCoreFormsPage_Checkbox_Required2}        [value="Specific pieces of personal information"]
${SiteCoreFormsPage_Checkbox_Required3}        [value="Personal details (name, address, age, gender, etc.)"]
${SiteCoreFormsPage_Label_FormSuccess}         .scf-form-title


*** Keywords ***

Verify Contact Us Form
    Run Keyword And Continue On Failure    Wait For Load State    networkidle
    Run Keyword And Continue On Failure    Check Mandatory Fields    5
    Run Keyword And Continue On Failure    Verify Form Submission    generic


Verify Request A Demo Form
    Run Keyword And Continue On Failure    Go To    ${PUBLIC_SITE_URL}/us-en/separately-managed-accounts
    Run Keyword And Continue On Failure    Check Mandatory Fields    5
    Run Keyword And Continue On Failure    Verify Form Submission    generic


Verify California Consumer Privacy Act Form
    Run Keyword And Continue On Failure    Wait For Load State    networkidle
    Run Keyword And Continue On Failure    Go To    ${PUBLIC_SITE_URL}/us-en/california-consumer-privacy-act-contact-form
    Run Keyword And Continue On Failure    Check Mandatory Fields    10
    Run Keyword And Continue On Failure    Verify Form Submission    CA


Check Mandatory Fields
    [Arguments]    ${field_count}
    Run Keyword And Continue On Failure    Click    ${SiteCoreFormsPage_Button_FormSubmit}
    Run Keyword And Continue On Failure    Get Element Count    ${SiteCoreFormsPage_Label_ValidationErrors}    equals    ${field_count}
    
    
Get All Events
    Run Keyword And Continue On Failure    Wait For Load State    networkidle
    ${dataLayer}    Run Keyword And Continue On Failure    Evaluate JavaScript    ${None}    window.dataLayer
    Run Keyword And Continue On Failure    Run Keyword And Return    Get Value From Json    ${dataLayer}    $..event


Fill Form Details
    [Arguments]    ${form_type}
    IF  '${form_type}' == 'generic'
        Run Keyword And Continue On Failure    Fill Text    ${SiteCoreFormsPage_Text_FullName}    ${Test_FirstName}+${Test_LastName}
        Run Keyword And Continue On Failure    Fill Text    ${SiteCoreFormsPage_Text_FirmName}    ${Test_CompanyName}
    ELSE IF  '${form_type}' == 'CA'
        Run Keyword And Continue On Failure    Click    ${SiteCoreFormsPage_Select_Required1}
        Run Keyword And Continue On Failure    Click    ${SiteCoreFormsPage_Option_Yes}
        Run Keyword And Continue On Failure    Click    ${SiteCoreFormsPage_Select_Required2}
        Run Keyword And Continue On Failure    Click    ${SiteCoreFormsPage_Option_Yes}
        Run Keyword And Continue On Failure    Evaluate Javascript    ${SiteCoreFormsPage_Checkbox_Required1}    (elem) => elem.click()
        Run Keyword And Continue On Failure    Click    ${SiteCoreFormsPage_Select_Required3}
        Run Keyword And Continue On Failure    Click    ${SiteCoreFormsPage_Option_Delete}
        Run Keyword And Continue On Failure    Evaluate Javascript    ${SiteCoreFormsPage_Checkbox_Required2}    (elem) => elem.click()
        Run Keyword And Continue On Failure    Evaluate Javascript    ${SiteCoreFormsPage_Checkbox_Required3}    (elem) => elem.click()
        Run Keyword And Continue On Failure    Fill Text    ${SiteCoreFormsPage_Text_FirstName}    ${Test_FirstName}
        Run Keyword And Continue On Failure    Fill Text    ${SiteCoreFormsPage_Text_LastName}    ${Test_LastName}
    END
    Run Keyword And Continue On Failure    Fill Text    ${SiteCoreFormsPage_Text_WorkEmail}    ${Test_Email}
    Run Keyword And Continue On Failure    Fill Text    ${SiteCoreFormsPage_Text_WorkPhone}    ${Test_PhoneNumber}
    Run Keyword And Continue On Failure    Fill Text    ${SiteCoreFormsPage_Text_Message}    ${Test_Message}


Verify Form Submission
    [Arguments]    ${form_type}
    ${events}    Get All Events
    Run Keyword And Continue On Failure    Should Not Contain    ${events}    lead_submit
    Run Keyword And Continue On Failure    Fill Form Details    ${form_type}
    Run Keyword And Continue On Failure    Click    ${SiteCoreFormsPage_Button_FormSubmit}
    Run Keyword And Continue On Failure    Get Text    ${SiteCoreFormsPage_Label_FormSuccess}    !=    ${EMPTY}
    ${events}    Get All Events
    Run Keyword And Continue On Failure    Should Contain    ${events}    lead_submit