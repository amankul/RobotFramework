FROM d/ubuntu:18.04

LABEL maintainer="Randy Schmidt <randy.schmidt@d.com>"
LABEL name="Docker build for acceptance testing of My d web site using Robot Framework"
LABEL version="1.0"
LABEL browsers="Chrome 75, Firefox 67, Opera"
LABEL tools="Python3.6, nodejs, npm, newman"

COPY requirements.txt .
RUN pip3 install -r requirements.txt
RUN pip3 install --upgrade robotframework-seleniumlibrary
RUN webdrivermanager firefox chrome opera --linkpath /usr/local/bin
RUN wget https://selenium-release.storage.googleapis.com/3.9/selenium-server-standalone-3.9.1.jar

RUN apt-get install -y firefox \
    && wget https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz \
	&& tar xvzf geckodriver-*.tar.gz \
	&& rm geckodriver-*.tar.gz \
	&& mv geckodriver /usr/local/bin \
	&& chmod a+x /usr/local/bin/geckodriver

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
	&& dpkg -i google-chrome*.deb \
	&& rm google-chrome*.deb

#RUN wget https://chromedriver.storage.googleapis.com/74.0.3729.6/chromedriver_linux64.zip \
RUN wget https://chromedriver.storage.googleapis.com/75.0.3770.90/chromedriver_linux64.zip \
	&& unzip chromedriver_linux64.zip \
	&& rm chromedriver_linux64.zip \
	&& mv chromedriver /usr/local/bin \
	&& chmod +x /usr/local/bin/chromedriver

RUN wget -qO- https://deb.opera.com/archive.key | apt-key add - \
	&& echo "deb https://deb.opera.com/opera-stable/ stable non-free" | tee /etc/apt/sources.list.d/opera-stable.list \
	&& apt-get update \
	&& apt-get install -y opera-stable

RUN apt-get install -y software-properties-common \
	&& curl -sL https://deb.nodesource.com/setup_12.x | bash - \
	&& apt-get install -y nodejs \
	&& node -v \
	&& npm -v

RUN apt-get update

COPY package.json .
RUN npm install -g

# Set display port to avoid crash
ENV DISPLAY=:99

CMD ["/scripts/run_suite.sh"]
