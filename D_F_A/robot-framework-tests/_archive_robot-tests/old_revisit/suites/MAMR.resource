*** Variables ***
# None

# ************************
# Test Objects - MAMR page
# ************************
${ACCESS_AND_AUTH_BOX}                              //html/body/div[1]/div/div/div/section[2]/div[1]/div
${ARTICLE_HEADER}                                   //html/body/div[1]/div/div[2]/section[1]/div/div/h1
${BROWSE_BY}                                        //section/div/div/p
${BROWSE_BY_FORMAT}                                 //section/div/div/div/div[2][count(. | //div[(text() = 'format' or . = 'format')]) = count(//div[(text() = 'format' or . = 'format')])]
${BROWSE_BY_SECTION}                                //div[3]/div/div/div[2]/section/div
${BROWSE_BY_TOPIC}                                  //section/div/div/div/div[count(. | //div[(text() = 'topic' or . = 'topic')]) = count(//div[(text() = 'topic' or . = 'topic')])]
${BROWSE_BY_USE}                                    //section/div/div/div/div[3][count(. | //div[(text() = 'use' or . = 'use')]) = count(//div[(text() = 'use' or . = 'use')])]
${BROWSE_BY_FILTER_SECTION}                         //html/body/div[1]/div/div[3]/div[1]/div/div[2]/section/div[1]/div[3]
${BROWSE_BY_FILTER_CLEAR}                           //div[@id='coveo119850ae']/div[2]/div[8]/div[2]/div
${CARD_1}                                           //div[@id='coveo06155413']/div[7]/div/a
${CARD_24}                                          //div[@id='coveo06155413']/div[7]/div[24]/a
${CARD_25}                                          //div[@id='coveo06155413']/div[7]/div[28]/a
${CARD_DOC}                                         //div[@id='coveo119850ae']/div[2]
${CLEAR}                                            //div[@id='coveo119850ae']/div[2]/div[8]/div[2]/div
${COOKIES_DIALOG}                                   //html/body/div/div[2]/div/div/div/div
${COOKIES_ACCEPT}                                   //html/body/div/div[2]/div/div/div/div/button
${CLEAR_ALL_FILTERS}                                //div[@id='coveo119850ae']/div[2]/div[8]/div[2]/div/div/div[2]
${CLICK_HERE_EMPLOYEE_LOGIN}                        //html/body/div[1]/div/div/div/section[2]/div[1]/div/div/div/div[2]/div/span[2]
${DIALOG_CHANGE_EMAIL}                              //html/body/div[4]/div/div
${DIALOG_CHANGE_EMAIL_CANCEL}                       css=button.profile-personal-infomation-modal-close > svg.imagex
${DIALOG_CHANGE_EMAIL_CANCEL_BTTN}                  //html/body/div[4]/div/div/form/div[2]/div[1]/button
${DIALOG_CHANGE_EMAIL_CONFIRM}                      //html/body/div[4]/div/div/form/div[1]/div[2]/input
${DIALOG_CHANGE_EMAIL_CONFIRM_REQUIRED}             //html/body/div[4]/div/div/form/div[1]/div[2]/span
${DIALOG_CHANGE_EMAIL_NEW}                          //html/body/div[4]/div/div/form/div[1]/div[1]/input
${DIALOG_CHANGE_EMAIL_NEW_INVALID}                  //html/body/div[4]/div/div/form/div[1]/div[1]/span
${DIALOG_CHANGE_EMAIL_LABEL}                        //html/body/div[4]/div/div/div[2]/h3
${DIALOG_CHANGE_EMAIL_SUBMIT_BTTN}                  //html/body/div[4]/div/div/form/div[2]/div[2]
${DIALOG_CHANGE_NAME}                               //html/body/div[3]/div/div
${DIALOG_CHANGE_NAME_CANCEL}                        css=button.profile-personal-infomation-modal-close > svg.imagex
${DIALOG_CHANGE_NAME_CANCEL_BTTN}                   //html/body/div[3]/div/div/div[2]/form/div[2]/div[1]/button
${DIALOG_CHANGE_NAME_FINISH_BTTN}                   //html/body/div[3]/div/div/div[2]/form/div[2]/div[2]/button
${DIALOG_CHANGE_NAME_FIRST}                         //html/body/div[3]/div/div/div[2]/form/div[1]/div[1]/input
${DIALOG_CHANGE_NAME_LABEL}                         //html/body/div[3]/div/div/div[2]/h3
${DIALOG_CHANGE_NAME_LAST}                          //html/body/div[3]/div/div/div[2]/form/div[1]/div[2]/input
${DIALOG_CHANGE_PASSWORD}                           //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[1]/button
${DIALOG_CHANGE_PASSWORD_BACK_BTTN}                 //html/body/div[5]/div/div/div[2]/div/button
${DIALOG_CHANGE_PASSWORD_CANCEL}                    //html/body/div[6]/div/div/div[1]/button/svg
${DIALOG_CHANGE_PASSWORD_LABEL}                     //html/body/div[6]/div/div/div[2]/div/h3
${DIALOG_CHANGE_PASSWORD_TIMEOUT}                   //html/body/div[6]/div/div
${DIALOG_CHANGE_PASSWORD_TIMEOUT_CANCEL}            //html/body/div[6]/div/div/button/svg
${DIALOG_CHANGE_PASSWORD_USE_SECURITY_BTTN}         //html/body/div[5]/div/div/div[2]/div/p[2]/button
${DIALOG_CHANGE_PASSWORD_USE_TEXT}                  //html/body/div[5]/div/div/div[2]/div/button
${DIALOG_CHANGE_PASSWORD_VERIFY_BTTN}               //html/body/div[6]/div/div/div[2]/div/button
${DIALOG_OPERATION_HAS_TIMED_OUT}                   //html/body/div[6]/div/div
${DIALOG_CHANGE_PHONE_VERIFICATION}                 //html/body/div[8]/div/div
${DIALOG_CHANGE_PHONE_VERIFICATION_LABEL}           //html/body/div[8]/div/div/div/div/h3
${DIALOG_CHANGE_PHONE_VERIFICATION_CHANGE}          //html/body/div[8]/div/div/div/div/div[1]/div[1]/div/div[2]/button
${DIALOG_CHANGE_PHONE_VERIFICATION_FINISH}          /
${DIALOG_CHANGE_PHONE_VERIFICATION_CANCEL}          /
${DIALOG_CHANGE_PHONE_VERIFICATION_NUMBER}          //html/body/div[8]/div/div/div/div/div[1]/div[1]/div/div[1]
${DIALOG_CHANGE_PHONE_VERIFICATION_SETUP_VOICE}     //html/body/div[8]/div/div/div/div/div[1]/div[2]/div/div[2]/button
${DIALOG_CHANGE_PHONE_VERIFICATION_VOICE}           /
${DIALOG_NAME_CHANGE_SUBMITTED}                     //html/body/div[3]/div/div
${DIALOG_NAME_CHANGE_SUBMITTED_BACK_BTTN}           //html/body/div[3]/div/div/div[2]/div/button
${DIALOG_NAME_CHANGE_SUBMITTED_LABEL}               //html/body/div[3]/div/div/div[2]/h3
${DIALOG_VERIFY_IDENTITY}                           //html/body/div[6]/div/div
${DIALOG_VERIFY_IDENTITY_CANCEL}                    /
${DIALOG_VERIFY_IDENTITY_CANCEL_BTTN}               //html/body/div[6]/div/div/div[2]/div/form/div/div[2]/button
${DIALOG_VERIFY_IDENTITY_NEXT_BTTN}                 //html/body/div[6]/div/div/div[2]/div/form/div/div[1]/button
${DIALOG_VERIFY_IDENTITY_SECURITY_ANSWER}           /
${DIALOG_VERIFY_IDENTITY_SECURITY_QUESTION}         /
${FAVORITES}                                        //section/div/div[2]/ul/li[5]/a
${FIND_AN_ADVISOR}                                  (//a[contains(text(),'Find an Advisor')])[2]
${HEADER}                                           //header/div/div[2]/div
${LOGIN_BUTTON}                                     //html/body/div/div[1]/div/div/section[2]/div/div/div[1]/div/div/form/button
${LOGIN_INCORRECT}                                  //html/body/div/div[1]/div/div/section[2]/div/div/div[1]/div/div/div[1]/div/p
${LOGIN_MAX_ATTEMPTS}                               //html/body/div/div[1]/div/div/section[2]/div/div/div[1]/div/div/div/p
${LOGIN_PASSWORD}                                   //html/body/div/div[1]/div/div/section[2]/div/div/div[1]/div/div/form/div[2]/input
${LOGIN_PASSWORD_REQUIRED}                          //html/body/div/div[1]/div/div/section[2]/div/div/div[1]/div/div/form/div[2]/span
${LOGIN_REMEMBER_ME}                                //*[@id="rememberMe"]
${LOGIN_USERNAME}                                   //html/body/div/div[1]/div/div/section[2]/div/div/div[1]/div/div/form/div[1]/input
${LOGIN_USERNAME_REQUIRED}                          //html/body/div/div[1]/div/div/section[2]/div/div/div[1]/div/div/form/div[1]/span
${MY_ACCOUNT}                                       (//a[contains(text(),'My Account')])[2]
${MY_REPORTS}                                       (//a[contains(text(),'My Reports')])[2]
${MY_SECRETS}                                       (//a[contains(text(),'My Secrets')])[2]
${NAV_EVENTS}                                       /
${NAV_FUNDS}                                        //html/body/div[1]/div[1]/div[1]/div/div/div[2]/header/div/div[2]/div/div/nav/ul/li[1]/button
${NAV_RESOURCES}                                    /
${NAV_TOOLS}                                        /
#${NUM_ITEMS}                                        //*[@id="coveo119850ae"]/div[2]/div[8]/div[1]/div/div/h4
${NUM_ITEMS}                                        //h4[@class='h4-left-medium-cool-gray home-main-content-number']
#${NUM_ITEMS}                                        //html/body/div[1]/div[1]/div[3]/div[2]/div/div[2]/div[8]/div[1]/div/div/h4
${PAGE_PROFILE}                                     //html/body/div[1]/div/div[2]/div/div/section[1]/div[1]
${PRIVACY_POLICY}                                   //div[3]/div[2]
${PRIVACY_POLICY_CLOSE}                             //div[2]/div/div/div[2]/a
${PROFILE_ACCOUNT_SETTINGS_TAB}                     //*[@id="0"]
${PROFILE_CONTAINER}                                //header/div/div[3]/div[2]/div
${PROFILE_CONTENT_PREFERENCES_LABEL}                //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[2]/div/div[3]/div[1]/div/h3
${PROFILE_COUNTRY}                                  //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[2]/div/div[3]/div/div/div/div[2]/div/span[2]
${PROFILE_COUNTRY_NO_NOTIFICATIONS}                 //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[2]/div/div[2]/div/div/div/div[2]/div/span[2]
${PROFILE_COUNTRY_CHANGE}                           //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[2]/div/div[3]/div[1]/div/div/div[1]/button
${PROFILE_COUNTRY_CHANGE_NO_NOTIFICATIONS}          //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[2]/div/div[2]/div/div/div/div[1]/button
${PROFILE_COUNTRY_CHANGE_ACCEPT}                    //html/body/div[5]/div/div/div/div/div[2]/div
${PROFILE_COUNTRY_CHANGE_DIALOG}                    //html/body/div[5]/div/div
${PROFILE_COUNTRY_CHANGE_DROPDOWN}                  //html/body/div[5]/div/div/div/div/div[1]/div[2]/div/div[2]/div[1]
${PROFILE_COUNTRY_CHANGE_SELECT}                    //html/body/div[5]/div/div/div/div/div[1]/div[1]/svg/polygon
${PROFILE_COUNTRY_LABEL}                            //html/body/div[1]/div/div[2]/div/div/section[2]/div[2]/div/div[3]/div[1]/div/div/div[1]/p
${PROFILE_EMAIL_ADDRESS}                            //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[2]/div/div[2]/p[2]
${PROFILE_EMAIL_ADDRESS_CHANGE}                     //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[2]/div/div[1]/button
${PROFILE_EMAIL_ADDRESS_LABEL}                      //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[2]/div/div[2]/p[1]
${PROFILE_EMAIL_NOTIFICATIONS}                      //html/body/div[1]/div/div[2]/div/div/section[2]/div[2]/div/div[2]/div/h3
${PROFILE_FEATURED_CONTENT_LABEL}                   //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[2]/div/div[3]/div[2]/p[1]
${PROFILE_FEATURED_CONTENT_BOTH}                    //html/body/div[1]/div/div[2]/div/div/section[2]/div[2]/div/div[3]/div[2]/ul/li[3]/div/div/button
${PROFILE_FEATURED_CONTENT_FA}                      //html/body/div[1]/div/div[2]/div/div/section[2]/div[2]/div/div[3]/div[2]/ul/li[1]/div/div/button
${PROFILE_FEATURED_CONTENT_INSTITUTIONAL}           //html/body/div[1]/div/div[2]/div/div/section[2]/div[2]/div/div[3]/div[2]/ul/li[2]/div/div/button
${PROFILE_NAME}                                     //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[1]/div/div[2]/div/div[1]/p[2]
${PROFILE_NAME_CHANGE}                              //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[1]/div/div[2]/div/div[1]/button
${PROFILE_NAME_LABEL}                               //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[1]/div/div[2]/div/div[1]/p[1]
${PROFILE_PREFERENCES_NOTIFICATIONS}                //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[2]/div/div[2]/div/h3
${PROFILE_PREFERENCES_WEEKLY_DIGEST}                //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[2]/div/div[2]/div/ul/div/input
${PROFILE_PASSWORD_CHANGE_BTTN}                     //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[1]/button
${PROFILE_PASSWORD_LABEL}                           //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[1]/p[1]
${PROFILE_PASSWORD_RESET_DATE}                      //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[1]/p[2]
${PROFILE_PERSONAL_INFO_HEADING}                    //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[1]/div/div[2]/div/h3
${PROFILE_PHONE_VERIFICATION_CHANGE}                //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[3]/button
${PROFILE_PHONE_VERIFICATION_LABEL}                 //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[3]/p
${PROFILE_PHONE_VERIFICATION_NUMBER}                //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[3]/div[1]/p[2]
${PROFILE_PHONE_VERIFICATION_TYPE}                  //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[2]/p[2]
${PROFILE_PREFERENCES_TAB}                          //*[@id="1"]
${PROFILE_PROFILE}                                  //html/body/div[1]/div/div[1]/div/div/div[2]/header/div/div[3]/div[2]/div/ul/li/a
${PROFILE_SECURITY_HEADING}                         //html/body/div[1]/div[1]/div[2]/div/div/section[2]/div[1]/div/div[3]/div/h3
${PROFILE_SECURITY_QUESTION_LABEL}                  //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[2]/p[1]
${PROFILE_SECURITY_QUESTION_RESET_DATE}             //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[2]/p[2]
${PROFILE_SECURITY_QUESTION_CHANGE}                 //html/body/div[1]/div/div[2]/div/div/section[2]/div[1]/div/div[3]/div/div[1]/button
${PROFILE_SIGN_OUT}                                 //html/body/div[1]/div[1]/div[1]/div/div/div[2]/header/div/div[3]/div[2]/div/div/a
${PROFILE_USER}                                     //html/body/div[1]/div[1]/div[1]/div/div/div[2]/header/div/div[3]/div[2]/button
${PROFILE_WEEKLY_DIGEST_EMAIL}                      //html/body/div[1]/div/div[2]/div/div/section[2]/div[2]/div/div[2]/div/ul/div/input
${QUICK_BUTTON_BAR}                                 //section/div/div[2]/ul
${SEARCH_CLOSE}                                     //html/body/div[1]/div[1]/div[1]/div/div/div[2]/header/div/div[3]/button
${SEARCH_FIELD}                                     //*[@id="coveoFDE5B0EB24D9"]/div[3]/div/input
${SEARCH_RESULTS}                                   //html/body/div[1]/div[1]/div[2]/section[1]/div[1]/div[1]/h2
${SELECTED_FILTER}                                  //div[@id='coveo119850ae']/div[2]/div[8]/div[2]/div/div/div[1]/div/span[2]/div  # Location of the 1st filter
${SHOW_MORE_BTTN}                                   //div[@id='coveo119850ae']/div[2]/div[9]/div[2]/button
${SORT_BY}                                          //section/div/div[2]/div/div/div[2]
${SORT_BY_LIST}                                     //section/div[1]/div[2]/div/div/ul
${USER_PROFILE}                                     //html/body/div[1]/div[1]/div[1]/div/div/div[2]/header/div/div[3]/div[2]/button
${VERIFY_IDENTITY_DIALOG}                           //html/body/div[5]/div/div
${VERIFY_IDENTITY_TEXT_VERIFICATION}                //html/body/div[5]/div/div/div[2]/div/button
${VERIFY_IDENTITY_SECURITY_QUESTION}                //html/body/div[5]/div/div/div[2]/div/p[2]/button
${VERIFY_IDENTITY_SECURITY_ANSWER}                  //html/body/div[5]/div/div/div[2]/div/form/div/div[1]/input
${VERIFY_IDENTITY_TIMED_OUT_TEXT}                   The operation has timed out. Try again
${WELCOME}                                          //html/body/div[1]/div/div[2]/section/div/div[1]/h3

# *********
# Constants
# *********
@{BROWSE_BY_FILTERS}                ${BROWSE_BY_TOPIC}  ${BROWSE_BY_FORMAT}  ${BROWSE_BY_USE}
@{SORT_BY_LABELS}                   NEWEST    RELEVANCE    # The Sort By available selections
${NEW_EMAIL_IS_INVALID}             New Email is invalid
${CONFIRM_EMAIL_IS_REQUIRED}        Confirm Email is required

# ****************
# Global Variables
# ****************

# ****
# APIs
# ****
