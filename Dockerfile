# Use an official Code Server image as the base
FROM codercom/code-server:latest

# Install necessary packages
USER root
RUN apt-get update && apt-get install -y \
    software-properties-common \
    vim \
    git \
    curl

# Add deadsnakes PPA for latest Python versions
RUN add-apt-repository ppa:deadsnakes/ppa

# Install the latest Python version (as of this writing, it's 3.11)
RUN apt-get update && apt-get install -y python3.11 python3.11-venv python3.11-dev

# Set python3.11 as the default python
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Install pip for the latest Python version
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3.11 get-pip.py

# Allow code-server to use sudo without a password
RUN echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# Expose the port Code Server runs on
EXPOSE 8080

# Start Code Server without authentication and keep the container alive
CMD ["sh", "-c", "code-server --bind-addr 0.0.0.0:8080 --auth none & while sleep 1000; do :; done"]
