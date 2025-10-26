FROM mcr.microsoft.com/devcontainers/base:noble
USER vscode
WORKDIR /home/vscode

# install python
RUN sudo apt-get update && \
    sudo apt-get -y install python3 python3-venv

# create python venv
RUN python3 -m venv .venv
ENV PATH=/home/vscode/.venv/bin:$PATH

# install openstackclient
COPY requirements.txt .
RUN pip install -r requirements.txt && \
    pip uninstall -y python-zaqarclient && \
    rm requirements.txt

## install packer
RUN sudo apt-get update && sudo apt-get install -y gnupg software-properties-common && \
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list && \
    sudo apt-get update && sudo apt-get install packer
