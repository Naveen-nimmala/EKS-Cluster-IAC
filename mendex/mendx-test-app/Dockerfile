FROM python:3.8.11-alpine3.14

COPY . /app

WORKDIR /app
#install required packages
RUN pip install -r requirements.txt

#Unit test
RUN python -m pytest app/test_app.py

CMD [ "hug", "-f", "app/app.py" ]