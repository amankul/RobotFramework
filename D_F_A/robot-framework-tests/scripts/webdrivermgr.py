from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager
from webdriver_manager.microsoft import EdgeChromiumDriverManager


def driverpath(browser='chrome'):
    if 'chrome' in browser.lower():
        return ChromeDriverManager().install()
    elif 'firefox' in browser.lower():
        return  GeckoDriverManager().install()
    elif 'edge' in browser.lower():
        return EdgeChromiumDriverManager().install()