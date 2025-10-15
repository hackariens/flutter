FROM debian:stable-slim

# Arguments de build
ARG FLUTTER_VERSION=3.35.5

# Variables
ENV FLUTTER_VERSION=${FLUTTER_VERSION}
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Dépendances nécessaires
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Installer Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME \
    && flutter doctor

# Pré-télécharger les artefacts pour éviter des téléchargements à chaque run
RUN flutter precache

# Vérifier l’installation
RUN flutter doctor -v

WORKDIR /app
