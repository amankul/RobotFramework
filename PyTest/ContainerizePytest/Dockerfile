FROM python:3.9-alpine
RUN mkdir /pytest-container-demo/
ADD .  /pytest-container-demo/ 
WORKDIR /pytest-container-demo/
RUN pip install --upgrade pip
RUN pip3 install -r req.txt
ENV GROUP="smoke"
ENTRYPOINT pytest -s -v -m ${GROUP} --disable-warnings