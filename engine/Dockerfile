FROM python:3.11-slim
RUN useradd -m cioran
WORKDIR /app/
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN chown -R cioran:cioran /app
USER cioran
EXPOSE 5000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "engine:app"]