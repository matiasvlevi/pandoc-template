# Use the LinuxServer code-server image as the base
FROM lscr.io/linuxserver/code-server:latest


RUN apt-get update && apt-get install -y \
    build-essential \
    pandoc \
    texlive \
    texlive-latex-extra \
    texlive-fonts-extra \
    && rm -rf /var/lib/apt/lists/*

# Copy local settings into the image
COPY settings.json /config/data/Machine/settings.json
