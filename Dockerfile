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

# Set working directory to Mailcow
WORKDIR /opt/mailcow-dockerized

# Set required environment variables
ENV TZ=UTC
ENV SKIP_UNBOUND_HEALTHCHECK=n

# Copy the prepared mailcow.conf file
COPY mailcow.conf ./mailcow.conf

# Hardcode SKIP_UNBOUND_HEALTHCHECK in docker-compose.yml
RUN sed -i 's/SKIP_UNBOUND_HEALTHCHECK=\${SKIP_UNBOUND_HEALTHCHECK:-n}/SKIP_UNBOUND_HEALTHCHECK=n/' docker-compose.yml

# Expose necessary ports
EXPOSE 25 587 993 110 995 143 443 80 443

# Entry point to start Mailcow
CMD ["docker-compose", "up", "-d"]
