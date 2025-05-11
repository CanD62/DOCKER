#!/bin/bash

# Nama dan tag image
IMAGE_NAME="reg.pcs.my.id/base/php73-apache"
IMAGE_TAG="1.0"
DOCKERFILE="Dockerfile.tmp"

# Generate Dockerfile langsung dari bash
cat <<EOF > "$DOCKERFILE"
FROM php:7.3-apache

LABEL maintainer="DevOps Team <devops@example.com>"

RUN apt-get update && apt-get install -y \\
    libzip-dev \\
    libjpeg62-turbo-dev \\
    libpng-dev \\
    libfreetype6-dev \\
    zlib1g-dev \\
    libcurl4-openssl-dev \\
    unzip \\
 && docker-php-ext-install \\
    mysqli \\
    zip \\
    mbstring \\
    curl \\
 && docker-php-ext-configure gd \\
    --with-jpeg-dir=/usr/include/ \\
    --with-png-dir=/usr/include/ \\
 && docker-php-ext-install gd \\
 && a2enmod rewrite \\
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

EXPOSE 80
EOF

# Login ke registry
echo "🔐 Login to Docker registry..."
docker login reg.pcs.my.id || exit 1

# Build
echo "🔧 Building image..."
docker build -f "$DOCKERFILE" -t "$IMAGE_NAME:$IMAGE_TAG" . || exit 1

# Push
echo "📤 Pushing image..."
docker push "$IMAGE_NAME:$IMAGE_TAG" || exit 1

# Cleanup (optional)
rm -f "$DOCKERFILE"

echo "✅ Selesai: $IMAGE_NAME:$IMAGE_TAG"
