FROM archlinux:latest

RUN pacman -Sy --noconfirm \
    bash \
    sudo \
    curl \
    vim \
    git \
    java \
    zsh \
    fish \
    && pacman -Scc --noconfirm

RUN useradd -m -s /bin/bash mysticgiggle && echo "mysticgiggle ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && echo "mysticgiggle:root" | chpasswd
USER mysticgiggle
WORKDIR /home/mysticgiggle
