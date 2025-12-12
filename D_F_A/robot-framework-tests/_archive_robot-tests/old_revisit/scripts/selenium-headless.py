from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from robot.libraries.BuiltIn import BuiltIn

import time

# tell selenium to use the dev channel version of chrome
# NOTE: only do this if you have a good reason to
#options.binary_location = '/usr/bin/google-chrome-unstable'
print("Setting up Chrome driver")
options = webdriver.ChromeOptions()
#options.add_argument('--headless')
options.add_argument('--disable-gpu')
options.add_argument('--privileged')
options.add_argument('--no-sandbox')

# set the window size
options.add_argument('window-size=1920x1080')

# initialize the driver
driver = webdriver.Chrome(chrome_options=options)
browserName = driver.capabilities['browserName']
browserVersion = driver.capabilities['browserVersion']  # Use for Chrome version 75+
#browserVersion = driver.capabilities['version']  # Use for Chrome version 74
print("Running {0} browser verion {1}".format(browserName, browserVersion))
version = BuiltIn().ROBOT_LIBRARY_VERSION
print("Robot Framework Version: {0}".format(version))

# wait up to 10 seconds for the elements to become available
driver.implicitly_wait(15)

driver.get('https://my-uat.d.com')

time.sleep(5)

print("Page title: " + driver.title)
driver.get_screenshot_as_file('reports/login-page.png')

# Login as an employee
employee_login = False
if employee_login:
    employee = driver.find_element_by_xpath('//html/body/div[1]/div/div/div/section[2]/div[1]/div/div/div/div[2]/div/span[2]')
    print("Found click here at ... " + employee.location)
    employee.click()
else:
    username = driver.find_element_by_xpath('//html/body/div[1]/div/div/div/section[2]/div[1]/div/div/div/form/div[1]/input')
    username.send_keys('dddx+Quinton.McHale@gmail.com')
    password = driver.find_element_by_xpath('//html/body/div[1]/div/div/div/section[2]/div[1]/div/div/div/form/div[2]/input')
    password.send_keys('Hlbbrs7!')
    login_bttn = driver.find_element_by_xpath('//html/body/div[1]/div/div/div/section[2]/div[1]/div/div/div/form/button')
    login_bttn.click()

time.sleep(10)

article_title = driver.find_element_by_xpath('//html/body/div[1]/div/div[3]/section[1]/div[1]/div[3]/div/h1/a').text
driver.find_element_by_xpath('//html/body/div[1]/div/div[3]/section[1]/div[1]').click()
wait = WebDriverWait(driver, 10)
wait.until(EC.title_contains(article_title))
#found = wait.until(
#            EC.visibility_of_element_located(
#                (By.XPATH, '//html/body/div[1]/div/div[2]/section[1]/div')
#            )
#        )

driver.find_element_by_xpath('/html/body/div[1]/div/div[1]/div/div/div[2]/header/div/div[2]/div/a').click()
wait.until(
    EC.visibility_of_element_located(
        (By.XPATH, '//*[@id="coveo119850ae"]/div[2]/div[8]/div[1]/div/div/h4')
    )
)

# take another screenshot
driver.get_screenshot_as_file('reports/featured-article.png')
print("Page title: " + driver.title)

driver.back()
time.sleep(2)

print("Page title: " + driver.title)
driver.get_screenshot_as_file('reports/browser-back-page.png')

driver.close()
