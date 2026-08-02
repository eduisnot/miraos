# Usamos la nueva ruta oficial del monorepo de Bootcrew con base Ubuntu
FROM ghcr.io/bootcrew/mono:ubuntu-26.04

# Instalar dependencias esenciales del sistema y kernel
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

# Añadir repositorios PPA para drivers gráficos Mesa actualizados
RUN add-apt-repository ppa:kisak/kisak-mesa -y && \
    apt-get update && \
    apt-get install -y mesa-vulkan-drivers mesa-va-drivers

# Configurar el repositorio Flathub de fábrica
RUN flatpak remote-add --if-not-exists flathub https://flathub.org

# Asegurar la persistencia y compatibilidad de Snapd en modo inmutable
RUN systemctl enable snapd.socket snapd.seeded.service

# Limpieza de paquetes temporales para ahorrar espacio
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
