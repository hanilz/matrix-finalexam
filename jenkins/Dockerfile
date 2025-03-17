# Stage 1 - builder
FROM python:3.9 AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2 - runner
FROM python:3.9-slim
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
EXPOSE 5001
CMD ["python", "app.py"]
