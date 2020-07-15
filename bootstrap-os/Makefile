# Makefile forked from https://github.com/lucasteligioridis/raspbernetes
#
# Use some sensible default shell settings
SHELL := /bin/bash -o pipefail
.SILENT:
.DEFAULT_GOAL := help

# Default variables
MNT_DEVICE ?= /dev/mmcblk0
MNT_ROOT    = /mnt/rpi/root
MNT_BOOT    = /mnt/rpi/boot
RPI_HOME    = $(MNT_ROOT)/home/pi
OUTPUT_PATH = workdir

# Raspberry PI host and IP configuration
RPI_NETWORK_TYPE ?= eth0
RPI_IP           ?= 192.168.1.102
RPI_GATEWAY      ?= 192.168.1.1
RPI_DNS          ?= $(RPI_GATEWAY)

# Raspbian image configuration
RASPBIAN_VERSION       = raspios_lite_armhf-2020-05-28
RASPBIAN_IMAGE_VERSION = 2020-05-27-raspios-buster-lite-armhf
#http://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2020-05-28/2020-05-27-raspios-buster-lite-armhf.zip
RASPBIAN_URL           = https://downloads.raspberrypi.org/raspios_lite_armhf/images/$(RASPBIAN_VERSION)/$(RASPBIAN_IMAGE_VERSION).zip
RASPBIAN_IMAGE_MD5     = 2e72763f00a8f8491753516b180e03b3 

write: prepare write-image mount configure unmount

.PHONY: configure
configure: ## Add dhcp configuration to set a static IP and gateway
	echo "Setting up config"
	sudo touch $(MNT_BOOT)/ssh
	echo "interface $(RPI_NETWORK_TYPE)" | sudo tee -a $(MNT_ROOT)/etc/dhcpcd.conf >/dev/null
	echo "static ip_address=$(RPI_IP)/24" | sudo tee -a $(MNT_ROOT)/etc/dhcpcd.conf >/dev/null
	echo "static routers=$(RPI_GATEWAY)" | sudo tee -a $(MNT_ROOT)/etc/dhcpcd.conf >/dev/null
	echo "static domain_name_servers=$(RPI_DNS)" | sudo tee -a $(MNT_ROOT)/etc/dhcpcd.conf >/dev/null
	sudo mkdir -p $(MNT_ROOT)/home/pi/.ssh
	cat ~/.ssh/id_rsa.pub | sudo tee -a $(MNT_ROOT)/home/pi/.ssh/authorized_keys >/dev/null
	sudo chown -R 1000:1000 $(MNT_ROOT)/home/pi/.ssh
	sudo chmod og-rwx $(MNT_ROOT)/home/pi/.ssh
	sudo chmod og-rwx $(MNT_ROOT)/home/pi/.ssh/authorized_keys 
	sync

.PHONY: write-image
write-image: ## Write raspbian lite image to SD card
	echo "Formatting SD card with $(RASPBIAN_IMAGE_VERSION).img"
	sudo dd if=./$(OUTPUT_PATH)/$(RASPBIAN_IMAGE_VERSION).img of=$(MNT_DEVICE) status=progress conv=fsync
	sync

.PHONY: mount
mount: ## Mount the current SD device
	echo "mount devices"
	sudo mount $(MNT_DEVICE)p1 $(MNT_BOOT)
	sudo mount $(MNT_DEVICE)p2 $(MNT_ROOT)

.PHONY: unmount
unmount: ## Unmount the current SD device
	echo "umount devices"
	sudo umount $(MNT_DEVICE)p1
	sudo umount $(MNT_DEVICE)p2

##@ Misc
.PHONY: help 
help: ## Display this help
	awk \
	  'BEGIN { \
	    FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n" \
	  } /^[a-zA-Z_-]+:.*?##/ { \
	    printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 \
	  } /^##@/ { \
	    printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	  }' $(MAKEFILE_LIST)

##@ Helpers
.PHONY: prepare
prepare: ## Create all necessary directories to be used in build
	sudo mkdir -p $(MNT_BOOT)
	sudo mkdir -p $(MNT_ROOT)
	echo "Downloading $(RASPBIAN_IMAGE_VERSION).zip..."
	wget -c $(RASPBIAN_URL) -O ./$(OUTPUT_PATH)/$(RASPBIAN_IMAGE_VERSION).zip
	unzip -n ./$(OUTPUT_PATH)/$(RASPBIAN_IMAGE_VERSION).zip -d ./$(OUTPUT_PATH)/
	rm -f ./$(OUTPUT_PATH)/$(RASPBIAN_IMAGE_VERSION).zip

.PHONY: clean
clean: ## Unmount and delete all temporary mount directories
	sudo umount $(MNT_DEVICE)p1 || true
	sudo rm -rf $(MNT_BOOT)
	sudo rm -rf $(MNT_ROOT)
