FROM python:3.11-slim
RUN useradd -m cioran
WORKDIR /app
RUN pip install flask gunicorn
COPY . .
RUN chown -R cioran:cioran /app
USER cioran
EXPOSE 5000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "engine:app"]