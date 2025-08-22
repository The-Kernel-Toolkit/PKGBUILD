FROM ghcr.io/the-kernel-toolkit/arch-pkgbuild:latest AS root

# Update packages and git repo
RUN yay -Syu --noconfirm --overwrite '*'
ENV USER=TKT
ENV HOME=/home/TKT
USER TKT
WORKDIR /home/TKT/PKGBUILDS
RUN git pull && chmod +x compile.sh

# Final command (login shell)
CMD ["/bin/bash", "-l"]
