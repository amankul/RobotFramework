*** Variables ***

${OrderPage_InputBox_Quantity}       [data-qa="printed-material-information-table-body-quantity-input"]
${OrderPage_Quantity_FirstBook}      ${5}
${OrderPage_Quantity_SecondBook}     ${8}
${OrderPage_Text_NoOfItems}          [data-qa="printed-materials-cart-title"]
${OrderPage_Button_Next}             [data-qa="printed-materials-cart-next"]
${OrderPage_Div_OrderForm}           [data-qa="printed-materials-checkout-content-container"]
${OrderPage_Input_FirstName}         [data-qa="printed-materials-checkout-first-name"]
${OrderPage_Input_LastName}          [data-qa="printed-materials-checkout-last-name"]
${OrderPage_Input_CompanyName}       [data-qa="printed-materials-checkout-company-name"]
${OrderPage_Input_BizAddress}        [data-qa="printed-materials-checkout-business-address"]
${OrderPage_Input_ZipCode}           [data-qa="printed-materials-checkout-zip"]
${OrderPage_Input_City}              [data-qa="printed-materials-checkout-city"]
${OrderPage_Input_PhoneNumber}       [data-qa="printed-materials-checkout-phone-number"]
${OrderPage_Dropdown_Countries}      [data-qa="printed-materials-checkout-form-country-dropdown"]
${OrderPage_Dropdown_States}         [data-qa="printed-materials-checkout-form-state-dropdown"]
${OrderPage_Option_CountrySelect}    [aria-label="${Test_Country}"]
${OrderPage_Option_StateSelect}      [aria-label="${Test_State}"]
${OrderPage_Button_Submit}           [data-qa="printed-materials-checkout-form-button"]
${OrderPage_Modal_OrderSuccess}      [data-qa="printed-materials-checkout-successed-container"]

*** Keywords ***

Enter Quantity and Verify Subtotal
    ${books}        Get Elements       ${OrderPage_InputBox_Quantity}
    ${selected_book}     Evaluate       random.sample(${books}, 2)
    Run Keyword And Continue On Failure    Get Classes         ${OrderPage_Button_Next}        contains        button-action-disabled-outline
    Run Keyword And Continue On Failure    Type Text        ${selected_book[0]}        ${OrderPage_Quantity_FirstBook}
    Run Keyword And Continue On Failure    Type Text        ${selected_book[1]}        ${OrderPage_Quantity_SecondBook}
    Get Text         ${OrderPage_Text_NoOfItems}        validate        str(${${OrderPage_Quantity_FirstBook} + ${OrderPage_Quantity_SecondBook}}) in value

Place Order
    Run Keyword And Continue On Failure    Click        ${OrderPage_Button_Next}
    Run Keyword And Continue On Failure    Wait For Elements State            ${OrderPage_Div_OrderForm}        visible
    Run Keyword And Continue On Failure    Click       ${OrderPage_Dropdown_Countries}
    Run Keyword And Continue On Failure    Click       ${OrderPage_Option_CountrySelect}
    Run Keyword And Continue On Failure    Type Text       ${OrderPage_Input_FirstName}          ${Test_FirstName}
    Run Keyword And Continue On Failure    Type Text       ${OrderPage_Input_LastName}     ${Test_LastName}
    Run Keyword And Continue On Failure    Type Text       ${OrderPage_Input_CompanyName}     ${Test_CompanyName}
    Run Keyword And Continue On Failure    Type Text       ${OrderPage_Input_BizAddress}     ${Test_BizAddress}
    Run Keyword And Continue On Failure    Type Text       ${OrderPage_Input_ZipCode}    ${Test_ZipCode}
    Run Keyword And Continue On Failure    Type Text       ${OrderPage_Input_City}       ${Test_City}
    Run Keyword And Continue On Failure    Type Text       ${OrderPage_Input_PhoneNumber}    ${Test_PhoneNumber}
    Run Keyword And Continue On Failure    Click        ${OrderPage_Dropdown_States}
    Run Keyword And Continue On Failure    Click        ${OrderPage_Option_StateSelect}
    Run Keyword And Continue On Failure    Click        ${OrderPage_Button_Submit}
    Wait For Elements State       ${OrderPage_Modal_OrderSuccess}             visible
