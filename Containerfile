# Usamos la base oficial y pública de Ubuntu (Evita el error 403)
FROM ubuntu:plucky

# Evitar preguntas interactivas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalar el sistema base, herramientas de inmutabilidad y el Kernel
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    linux-image-generic \
    systemd-sysv \
    udev \
    dbus \
    flatpak \
    gnome-software-plugin-flatpak \
    snapd \
    curl \
    git \
    software-properties-common \
    distrobox

# 2. Instalar los componentes necesarios para que sea un sistema "bootc"
RUN apt-get install -y --no-install-recommends \
    ostree \
    skopeo \
    polkitd

# Declaramos formalmente que esta imagen es un contenedor arrancable de bootc
LABEL containers.bootc=1

# 3. Añadir drivers gráficos Mesa actualizados (PPA Kisak)
RUN add-apt-repository ppa:kisak/kisak-mesa -y && \
    apt-get update && \
    apt-get install -y mesa-vulkan-drivers mesa-va-drivers

# 4. Configurar el repositorio Flathub de fábrica
RUN flatpak remote-add --if-not-exists flathub https://flathub.org

# 5. Forzar la activación de Snapd en entornos de solo lectura
RUN systemctl enable snapd.socket snapd.seeded.service

# Limpieza para que la ISO no pese de más
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
