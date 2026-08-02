FROM ghcr.io/bootcrew/ubuntu-bootc:rolling

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    linux-image-generic \
    flatpak \
    gnome-software-plugin-flatpak \
    snapd \
    curl \
    git \
    software-properties-common \
    distrobox

RUN add-apt-repository ppa:kisak/kisak-mesa -y && \
    apt-get update && \
    apt-get install -y mesa-vulkan-drivers mesa-va-drivers

RUN flatpak remote-add --if-not-exists flathub https://flathub.org

RUN systemctl enable snapd.socket snapd.seeded.service

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
