#!/bin/sh

setup() {
	sleep 10
	exec /setup
}


RSIZE='16G'
[ -n "${RAM_SIZE}" ] && RSIZE=${RAM_SIZE}

DSIZE='64G'
[ -n "${DISK_SIZE}" ] && DSIZE=${DISK_SIZE}

KVM=""
[ -f /dev/kvm ] && KVM=-enable-kvm

echo "create disk image..."
qemu-img create -f qcow2 /void/disk1.qcow2 ${DSIZE}

setup &

qemu-system-x86_64 -no-reboot \
    -m ${RSIZE} -smp 8 \
    -machine q35 ${KVM} \
    -netdev user,id=n0,hostfwd=tcp::2375-:2375 -device rtl8139,netdev=n0 \
    -drive file=/void/void-live-x86_64-musl-20230628-base.iso,if=ide,index=1,media=cdrom \
    -drive file=/void/disk1.qcow2,if=ide,index=3,media=disk \
    -kernel /void/vmlinuz \
    -initrd /void/initrd \
    -serial telnet::4444,server,nowait \
    -nographic -append "console=ttyS0 root=live:/dev/sr0 vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8  rd.live.overlay.overlayfs=1"
