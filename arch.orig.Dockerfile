FROM ghcr.io/the-kernel-toolkit/arch-pkgbuild:latest AS root
ENV USER=root
ENV HOME=/
USER root
WORKDIR /

# Copy base files
COPY distro-files/etc/bash.bashrc /etc/bash.bashrc
COPY distro-files/etc/environment /etc/environment
COPY distro-files/etc/makepkg.conf /etc/makepkg.conf
COPY distro-files/etc/pacman.conf /etc/pacman.conf
COPY distro-files/etc/pacman.d/cachyos-mirrorlist /etc/pacman.d/cachyos-mirrorlist
COPY distro-files/etc/pacman.d/chaotic-mirrorlist /etc/pacman.d/chaotic-mirrorlist
COPY distro-files/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
COPY distro-files/etc/profile /etc/profile
COPY distro-files/etc/resolv.conf /etc/resolv.conf
COPY distro-files/etc/shells /etc/shells

# Update and install base-devel and other needed packages
RUN pacman -Syu --needed --noconfirm --asexplicit yay

# Cleanup some uneccesary files
RUN rm -rf \
    /usr/{var/cache/pacman/pkg/*,share/locale/en{@boldquot,@quot,@shaw,_AU,_CA,_GB,_NZ}}

# Create TKT user, install yay, upgrade, and init repo
#RUN useradd --badname -U -m TKT && \
#    mkdir -p /home/TKT/.config/yay
COPY distro-files/yay_config.json /home/TKT/.config/yay/config.json
RUN chown -R TKT:TKT /home
COPY distro-files/etc/passwd /etc/passwd
COPY distro-files/etc/sudoers.d/TKT /etc/sudoers.d/TKT
ENV USER=TKT
ENV HOME=/home/TKT
USER TKT
WORKDIR /home/TKT
RUN yay -Su --noconfirm --overwrite '*' \
    acl alsa-lib art_standalone audit aria2 base-devel bash bash-complete-alias bash-completion bc binutils bionic_translation \
    bison brotli c-ares cabal-install2 ca-certificates ccache cairo clang-git compiler-rt-git coreutils cppdap cryptsetup \
    cpio curl dbus diffutils doxygen electron expat fakeroot ffmpeg filesystem flex fuse2 gawk gcc gcc-libs gd gdk-pixbuf2 \
    gettext giflib glib2 glibc glslang gmp gperf graphviz graphene grep grpc gzip hicolor-icon-theme icu imagemagick inetutils \
    initramfs isl jansson jsoncpp kdialog kmod lib32-gcc-libs lib32-libxcb lib32-libx11 lib32-libva lib32-ncurses lib32-openal \
    lib32-spirv-tools lib32-vkd3d lib32-vulkan-icd-loader lib32-wayland libarchive libcap libcap-ng libedit libelf libffi libgcrypt \
    libjpeg-turbo libnghttp2 libnghttp3 libngtcp2 libnl libpciaccess libpng libseccomp libslang libsystemd libtiff libtool libudev \
    libunwind libuv libvulkan libx11 libxau libxcb libxcursor libxinerama libxi libxrandr libxml2 libzip llvm-git llvm-libs-git linux-api-headers \
    linux-firmware lld-git lzo lz4 m4 make mallard-ducktype mesa meson mkinitcpio nano ncurses nodejs numactl nvm \
    openssl pahole pam patch patchutils pciutils schedtoolscx-scheds sed sh slang spirv-headers spirv-tools sudo systemd systemd-libs tar texinfo \
    texlive-core texlive-latexextra time tzdata upx util-linux wget wireless-regdb wine wireless-regdb \
    xcb-proto xorgproto xmlto xz yaml yay z3 zlib-ng-compat zstd

# Cleanup some uneccesary files again
ENV USER=root
ENV HOME=/
USER root
WORKDIR /
RUN rm -rf \
    /usr/{var/cache/pacman/pkg/*,share/locale/en{@boldquot,@quot,@shaw,_AU,_CA,_GB,_NZ}}

ENV USER=TKT
ENV HOME=/home/TKT
USER TKT
#WORKDIR /home/TKT

#RUN git clone --depth 1 https://github.com/ETJAKEOC/PKGBUILDS /home/TKT/PKGBUILDS
WORKDIR /home/TKT/PKGBUILDS
RUN git pull && chmod +x compile.sh

# Final command (login shell)
CMD ["/bin/bash", "-l"]
