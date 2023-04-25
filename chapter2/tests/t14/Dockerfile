FROM python:3.10.11-slim-buster AS builder

WORKDIR /app
COPY memory.py requirements.txt ./
RUN apt-get update && apt-get install -y gcc=4:8.3.0-1 python3-dev=3.7.3-1 musl-dev=1.1.21-2 --no-install-recommends
RUN pip install --no-cache-dir -r requirements.txt --upgrade pip && pip install --no-cache-dir -r requirements.txt

COPY . .

FROM gcr.io/distroless/python3@sha256:c472650ee9b43ce1bb7efa2960c95c046fa44f7258ae22f9ceb3d3f49f26d010 AS runtime

COPY --from=builder /app /app
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
ENV PYTHONPATH=/usr/local/lib/python3.10/site-packages
CMD ["/app/memory.py"]
