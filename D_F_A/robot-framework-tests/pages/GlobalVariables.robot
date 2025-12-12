*** Variables ***

# Miscellaneous
${CareerOpenings_Host}                              workday
${CareerOpenings_Internships_Param}                 ?workerSubType=b5337b8356eb10df51eeca92a634f163
${CareerOpenings_Careers_Param}                     DFA_Careers
${CareersPage_Option_Internships}                   Internships
${CareersPage_Option_Professionals}                 Professionals
${FFForum_Essay}                                    FAANG
${FFForum_Cat}                                      Hedge
${FFForum_About}                                    French
${People_ExecSearch}                                David Booth
${People_Bio}                                       1992年、ユージン F. ファーマ氏との共著論文"Diversification Returns and Asset Management"でファイナンシャル・アナリスト・ジャーナル誌よりGraham and Dodd Award of Excellenceを受賞するなど、数多くの論文を著す
${People_BioLanguages}                              Japanese (Japan)
${Seconds_in_Day}                                   86400
${DailyTransactionReport_VehicleCode}               SEMC
${PlatinumReport_EmailSent}                         Report request has been submitted
${Test_FirstName}                                   Tëst
${Test_LastName}                                    Automation
${Test_CompanyName}                                 DFA
${Test_Email}                                       test@d.com
${Test_BizAddress}                                  160 qüestió Ave
${Test_ZipCode}                                     M4P 3B5
${Test_City}                                        Toronto
${Test_PhoneNumber}                                 416-922-7181
${Test_Country}                                     Canada
${Test_State}                                       Ontario
${Test_ProfessionalType}                            Institution
${Test_Message}                                     DFA-REGRESSION-TESTING
@{ClientSite_TestUX_CountryList}                    Australia    Canada    Hong Kong    United Kingdom    United States
${Accordian_Page_PathUS}                            collections/4s/sustainability-investing
@{FeaturedPage_Format_Values}                       ARTICLE    VIDEO    OTHER RESOURCES
@{FeaturedPage_Use_Values}                          CLIENT READY    PROFESSIONAL
&{BrowseBar_TopicFormatUse}                         tagtopic=ESG    browseformat=Collection    resultuse=Professional
${IAP_PathUS}                                       asset/152493/etf-share-class-cboe-filing-template-comment-letter
# @{SRRI_Doc_Types}                                   Fact Sheet    Sustainability Considerations    # commenting this use for now.
${QA_Test_Characterset}                             ありがとう1 .^™℠®©äöü,ßaB`~
${HomePage_Links_Footer}                            [data-qa="footer-link"]
${HomePage_Label_Header}                            .nav-links-main-label
${HomePage_Container_Sub-header}                    .nav-links-sub
${HomePage_Links_Header}                            [data-qa*="nav-header-link-"]
@{Image_Extensions}                                 jpg    jpeg    png    gif    webp
${Youtube_Relative_URL}                             https://www.youtube.com/watch?v=

# Credentials Related
# All passwords were changed on 05-20-2024
*** Variables ***
${Okta_Username}                                    [data-se="o-form-input-identifier"] >> input
${Okta_Password}                                    [data-se="o-form-input-credentials.passcode"] >> input
${Okta_Submit}                                      .o-form-button-bar
${Okta_GrantType}                                   client_credentials
${Okta_Scope}                                       crmapi:all:r
@{ClientSite_MAMRLogin}                             dddx+mamr.qaautomation@gmail.com            S!tecore01010001
@{ClientSite_MAMRLogin1}                            dddx+mamr.qaautomation1@gmail.com           S!tecore01010001
@{ClientSite_GenericLogin}                          dddx+clientsite.qaautomation@gmail.com      S!tecore01010001
@{ClientSite_GenericLogin1}                         dddx+clientsite.qaautomation1@gmail.com     S!tecore01010001
@{ClientSite_GenericLogin2}                         dddx+clientsite.qaautomation2@gmail.com     S!tecore01010001
@{ClientSite_GenericLogin3}                         dddx+clientsite.qaautomation3@gmail.com     S!tecore01010001
@{ClientSite_GenericLogin4}                         dddx+clientsite.qaautomation4@gmail.com     S!tecore01010001
@{ClientSite_GenericLogin5}                         dddx+clientsite.qaautomation5@gmail.com     S!tecore01010001
@{ClientSite_GenericLogin6}                         dddx+clientsite.qaautomation6@gmail.com     S!tecore01010001
@{ClientSite_GenericLogin7}                         dddx+clientsite.qaautomation7@gmail.com     S!tecore01010001
@{ClientSite_GenericLogin8}                         dddx+clientsite.qaautomation8@gmail.com     S!tecore01010001
@{ClientSite_GenericLogin9}                         dddx+clientsite.qaautomation9@gmail.com     S!tecore01010001
@{ClientSite_GenericLogin10}                        dddx+clientsite.qaautomation10@gmail.com    S!tecore01010001
@{ClientSite_GenericLogin11}                        dddx+clientsite.qaautomation11@gmail.com    S!tecore01010001
@{ClientSite_GenericLogin12}                        dddx+clientsite.qaautomation12@gmail.com    S!tecore01010001
@{ClientSite_GenericLogin13}                        dddx+clientsite.qaautomation13@gmail.com    S!tecore01010001
@{ClientSite_GenericLogin14}                        dddx+clientsite.qaautomation14@gmail.com    S!tecore01010001
@{ClientSite_GenericLogin15}                        dddx+clientsite.qaautomation15@gmail.com    S!tecore01010001
@{ClientSite_GenericLogin16}                        dddx+clientsite.qaautomation16@gmail.com    S!tecore01010001
@{ClientSite_GenericLogin17}                        dddx+clientsite.qaautomation17@gmail.com    S!tecore01010001
@{ClientSite_ShadforthLogin}                        dddx+shadforth.qaautomation@gmail.com       S!tecore01010001
@{ClientSite_SuccessionLogin}                       dddx+succession.qaautomation@gmail.com      S!tecore01010001
${ClientSite_Login_AnotherMethod_SecurityAnswer}    panda
${ClientSite_TestUser}                              qaautomation


# Test Pages
${FeaturedArea_CMSPage_Path}                      dev-lab/qa-test-pages/featured-home
${PDFConverter_CMSPage_Path}                      content/2025/market-review-2024-stocks-overcome-uncertainty-to-notch-another-strong-year
${Powerpoint_CMSPage_Path}                        dev-lab/qa-test-pages/content-pages/tuning-out-the-noise
${Accordian_CMSPage_Path}                         dev-lab/qa-test-pages/test-accordion-page
${Pause_CMSPage_Path}                             dev-lab/qa-test-pages/content-pages/what-is-the-social-cost-of-carbon
${Shadforth_CMSPage_Path}                         dev-lab/qa-test-pages/content-pages/david-booth-on-the-old-normal
${Succession_CMSPage_Path}                        dev-lab/qa-test-pages/becoming-a-retirement-plan-advisor
${AboutUs_CMSPage_PathUS}                         us-en/dev-lab/qa-test-pages/about-us
${OurApproach_CMSPage_PathUS}                     us-en/dev-lab/qa-test-pages/our-approach
${AboutUs_CMSPage_PathDE}                         de-de/dev-lab/qa-test-pages/about-us
${ProHome_CMSPage_Path}                           us-en/dev-lab/qa-test-pages/financial-professionals
${IndHome_CMSPage_Path}                           us-en/dev-lab/qa-test-pages/individual
${dDifference_CMSPage_PathUS}           us-en/dev-lab/qa-test-pages/d-difference
${dDifference_Page_Path}                us-en/our-philosophy
${dDifference_CMSPage_PathDE}           de-de/dev-lab/qa-test-pages/d-difference
${d360_CMSPage_Path}                    us-en/dev-lab/qa-test-pages/d-360
${Institutions_CMSPage_Path}                      us-en/financial-professionals/work-with-us/institutions
${RemembranceModalPortrait_CMSPage_Path}          us-en/dev-lab/qa-test-pages/remembrance-page-portrait
${RemembranceModalSilhouette_CMSPage_Path}        us-en/dev-lab/qa-test-pages/remembrance-page-silhouette
${ExhibitComponent_CMSPage_Path}                  us-en/dev-lab/qa-test-pages/content-pages/exhibit-component-page
${ClientLoginClientReady_CMSPage_Path}            dev-lab/qa-test-pages/content-pages/us-equity-returns-following-past-downturns
${AudioComponent_Page_Path}                       insights/managing-your-practice
${EventsSchedule_Page_Path}                       us-en/financial-professionals/d-360/events-schedule
${Insights_CMSPage_Path}                          dev-lab/qa-test-pages/insights
${Collections_CMSPage_Path}                       dev-lab/qa-test-pages/qa-collection-page


# Color Library - Alphabetized
${AlmostBlack}                                rgb(51, 63, 72)
${Black}                                      rgb(0, 0, 0)
${Blue01}                                     rgb(0, 77, 113)
${Cement02}                                   rgb(209, 224, 215)
${CoolGray00}                                 rgb(91, 103, 111)    # This color is not in our design color library as it was custom created.
${CoolGray01}                                 rgb(74, 84, 92)
${CoolGray02}                                 rgb(110, 120, 127)
${CoolGray03}                                 rgb(162, 170, 173)
${CoolGray04}                                 rgb(199, 204, 206)
${Green01}                                    rgb(115, 123, 76)
${Green02}                                    rgb(181, 189, 0)
@{Lottie_AchievementsColors}                  teal     seafoam    yellow
${Poppy01}                                    rgb(255, 80, 51)
${Teal00}                                     rgb(0, 77, 83)    # This color is not in our design color library as it was custom created.
${Teal01}                                     rgb(0, 102, 110)
${Teal02}                                     rgb(0, 126, 135)
${Teal03}                                     rgb(0, 145, 156)
${Teal04}                                     rgb(0, 183, 189)
${Teal05}                                     rgb(98, 224, 201)
@{TealShades}                                 ${Teal03}    ${Teal02}    ${Teal01}    ${Teal00}
${WarmGray01}                                 rgb(125, 125, 122)
${WarmGray02}                                 rgb(160, 160, 157)
${WarmGray04}                                 rgb(210, 210, 208)
${WarmGray05}                                 rgb(228, 228, 227)
${WarmGray06}                                 rgb(245, 245, 244)
${White}                                      rgb(255, 255, 255)
${Yellow01}                                   rgb(196, 176, 0)
${Yellow02}                                   rgb(199, 185, 13)
${Yellow03}                                   rgb(255, 233, 0)

# DDX Global Color Library - Alphabetized
${CoolGray800}                               rgb(117, 126, 133)
${CoolGray900}                               rgb(97, 107, 115)
${CoolGray1100}                              rgb(59, 72, 81)
${CoolGray1200}                              rgb(49, 60, 67)
${Teal900}                                   rgb(6, 122, 131)
