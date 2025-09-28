FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat \
    bash \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY wisecow.sh .

# Fix Windows line endings and make script executable
RUN sed -i 's/\r$//' wisecow.sh && chmod +x wisecow.sh

CMD ["./wisecow.sh"]


