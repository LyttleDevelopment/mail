FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    docker-compose \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the Mailcow repository
WORKDIR /opt
RUN git clone https://github.com/mailcow/mailcow-dockerized.git

# Set environment variables (adjust these as needed)
WORKDIR /opt/mailcow-dockerized
COPY mailcow.conf .

# Expose necessary ports
EXPOSE 25 587 993 110 995 143 443

# Entry point to start Mailcow
CMD ["docker-compose", "up"]
