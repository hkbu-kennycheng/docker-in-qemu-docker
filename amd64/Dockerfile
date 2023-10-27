FROM alpine

RUN apk update && apk add --no-cache wget 7zip inetutils-telnet \
    qemu-img qemu-system-x86_64 qemu-modules expect 

RUN mkdir /void && cd /void && \
  wget https://repo.jing.rocks/voidlinux/live/current/void-live-x86_64-musl-20230628-base.iso

RUN 7z e /void/void-live-x86_64-musl-20230628-base.iso -o/void boot/initrd boot/vmlinuz

ADD setup /setup
ADD run.sh /run.sh

EXPOSE 2375

CMD /run.sh
