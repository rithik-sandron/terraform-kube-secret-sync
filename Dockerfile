FROM python:3.8

COPY requirements.in .

RUN pip install -r requirements.in

COPY main.py .

ENTRYPOINT ["python", "main.py"]
