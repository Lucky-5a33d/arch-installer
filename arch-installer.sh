#!/bin/bash

function boot_mode(){
	#check the UEFI bitness
	if [[ -f /sys/firmware/efi/fw_platform_size ]];then
		UEFI=true
		echo 'your system booted in UEFI'
	else
		UEFI=false
		echo 'you system booted in BIOS'
	fi
}

#connectivity
#until [[ ping -c 2 google.com ]] ;do
#	station name connect SSID

function partition_format_mount(){
	#dick patitions
	disks=$(lsblk -d -e 7,11 -o NAME|sed '1d')

	disks_number=0
	for disk in $disks;do
		(( disks_number++ ))
		echo "$disks_number)$disk"
	done
	read -p "what disk you whant to chosss(1...$disks_number) [defult:1]: " disk_num
	disk_num=${disk_num:-1}
	chdisk="/dev$(echo "$disks" |sed "$disk_num!d")"
	echo "you choosen disk is $chdisk"
	
	read -p "Do you want to partition the disk manually? (yes/no) [default: no]: " choice
	choice=${choice:-no}
	
	if [[ "$choice" == "yes" ]]; then
		echo "Starting manual partitioning..."


		# Validate the disk
		if [ ! -b "$chdisk" ]; then
		echo "Error: $chdisk is not a valid block device."
		exit 1
		fi

		# Launch fdisk for manual partitioning
		echo "Launching fdisk for manual partitioning. Press 'Quit' to write changes and exit when done."
		cfdisk "$chdisk"

		echo "Manual partitioning complete."

	else
		echo "Proceeding with automatic partitioning..."
		Add your automatic partitioning logic here

		if [ ! -b "$disk" ]; then
		echo "Error: $disk is not a valid block device."
		exit 1
		fi
		disk_size=$(lsblk -d $chdisk -o SIZE|sed 'd1')
		ram_size=$(cat /proc/meminfo|grep MemTotal|awk '{print$2}')
		swap_part=""
		root_part=""
		if [[ $disk_size -gt 20 ]];then 
			if [[ $ram_size -gt 3900000 ]];then
				swap_part="n
				
				
				+4G
				t
				swap"
				
			elif [[ $ram_size -gt 900000 && $ram_size -lt 3900000  ]]
				swap_part="n
				
				
				+4G
				t
				swap"
			else 
				swap_part=
			fi
		else
			swap_part=
		fi
		fdisk "$disk" <<EOF
g
n


+512M
t
uefi
$swap_part
n



q
EOF
}
partition_format_mount




	#fdisk /dev/$s &>/dev/null <<EOF
	#g
	#n
	#
	#
	#size
	#t
	#type
	#n
	#
	#
	#size
	#t
	#type
	#w
	#EOF
	#



	#formathing hard
	#mkfs.ext4 /dev/root_partition
	# mkswap /dev/swap_partition
	# mkfs.fat -F 32 /dev/efi_system_partition
	#
	#
	#

