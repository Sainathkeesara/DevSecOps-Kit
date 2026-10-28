# last_verified: 2026-10-28 · docker n/a
# Build a small app image with Docker from scratch
# I wanted a minimal base to start from for my own projects, and this Dockerfile
# became the template I copy into every new small-app project.

FROM alpine:3.19 AS builder

# Create a non-root user for running the application
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy only the requirements first for layer caching (if using Python)
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# Create a minimal script that just outputs a greeting
RUN mkdir -p /app && \
    echo 'print("Hello from my small app image!")' > /app/main.py

# Use a minimal base for the final stage
FROM alpine:3.19

# Create the same non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy the application from the builder stage
COPY --from=builder /app/main.py /app/main.py

# Set the user to appuser for security
USER appuser

# Default command when the container starts
CMD ["python", "/app/main.py"]