#!/bin/bash
## Troubleshooting script for Cyberseclabs.co.uk
## Updated 4/10/20

# Check the user
# Date
# VM Check
# Network Interfaces output
# Network routes check
# DNS information
# Ping test to google
# Ping test to internal VPN
# Print the external IP address
# Run the UDP port test
# Check the kernel Version
# Check the OS version
# Conclusion of test notice







## Global vars

# Colors for bash
#ROYGBIV
RED="\033[01;31m"
ORANGE="\033[0;33m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
BLUE="\033[1;34m"
INDIGO="\033[01;35m"
VIOLET="\033[01;35m"

#Reset will clear whatever color was before
RESET="\033[00m"
BOLD="\033[01;01m"


# Creating the file for the user
echo -e "${BOLD} --- START OF CSL TROUBLESHOOT SCRIPT --- ${RESET}" | tee troubleshoot.log


## Banner
echo -e "\n${ORANGE}[+]${RESET} Once this has completed, \
please send the log named 'troubleshoot.log' to ${BOLD}support@cyberseclabs.co.uk${RESET}"
sleep 3s


## Checking user, and user permissions
echo -e "\n\n${ORANGE} --- Checking user --- ${RESET}"
echo -e "\n\n--- Checking user ---" > troubleshoot.log
if [[ "${EUID}" -ne 0 ]]; then
    # Not sure if the RESET is needed here or not
    echo -e "${RED}[-]${RESET} This script must be run as ${RED}root${RESET}. \nEnding."
    echo -e "[-] This script must be run as root. Ending." >> troubleshoot.log
    sleep 3s
    exit 1
fi
id | tee -a troubleshoot.log
sleep 2s

## Since by this point, the user has verified that they are root, can now contiue

## Is the user connected to VPN on interface tun0
echo -e "\n\n${ORANGE} --- tun0 interface test --- ${RESET}"
echo -e "\n\n --- tun0 interface test --- " >> troubleshoot.log
if ( ip a | grep -iq tun0); then
    echo -e "${GREEN}[+]${RESET} You appear to be connected to something on interface tun0." | tee -a troubleshoot.log
else
    echo -e "${RED}[-]${RESET} You do not appear to be connected on interface tun0." | tee -a troubleshoot.log
    sleep 3s
    exit 1
fi


## OS information
echo -e "\n\n${ORANGE} --- Operating System information --- ${RESET}"
echo -e "\n\n --- Operating System Information --- " >> troubleshoot.log
cat /etc/issue | tee -a troubleshoot.log
cat /etc/*-release | tee -a troubleshoot.log
sleep 3s

## Date
echo -e "\n\n${ORANGE}--- Date --- ${RESET}"
echo -e "\n\n --- Date ----" >> troubleshoot.log
date | tee -a troubleshoot.log
sleep 3s

## Virtual Machine check
echo -e "\n\n${ORANGE} --- Virtual Machine check --- ${RESET}"
echo -e "\n\n --- Virtual Machine check ---" >> troubleshoot.log
if (dmidecode | grep -iq vmware); then
    echo -e "${ORANGE}[i]${RESET} VMware has been detected." | tee -a troubleshoot.log
elif (dmidecode | grep -iq virtualbox); then
    echo -e "${ORANGE}[i]${RESET} VirtualBox has been detected." | tee -a troubleshoot.log
else
    echo -e "${ORANGE}[i]${RESET} No virtual machine was detected." | tee -a troubleshoot.log
fi
sleep 2s

## Network routes and interfaces
echo -e "\n\n${ORANGE} --- Network Routes & Interfaces --- ${RESET}"
echo -e "\n\n --- Network Routes & Interfaces --- " >> troubleshoot.log
route -n | tee -a troubleshoot.log
echo -e "\n${ORANGE}[i]${RESET} Interfaces" | tee -a troubleshoot.log
ip a | tee -a troubleshoot.log
sleep 2s

## DNS inforation
echo -e "\n\n${ORANGE} --- DNS Information --- ${RESET}"
echo -e "\n\n --- DNS Information --- " >> troubleshoot.log
echo -e "\n${ORANGE}[i]${RESET} resolv.conf contents" && cat /etc/resolv.conf | tee -a troubleshoot.log
echo -e "\n${ORANGE}[i]${RESET} Digging google.com" && dig google.com | tee -a troubleshoot.log
sleep 2s



## External ping test
echo -e "\n\n${ORANGE} --- External Ping Test (www.google.com) --- ${RESET}"
echo -e "\n\n --- External Ping Test (www.google.com) --- " >> troubleshoot.log
ping -c 8 8.8.8.8 | tee -a troubleshoot.log



## Internal Ping test
echo -e "\n\n${ORANGE} --- Internal Ping Test (self-ip on tun0) --- ${RESET}"
echo -e "\n\n --- Internal Ping Test (self-ip on tun0) --- " >> troubleshoot.log
ping -c 8 $(ip a | grep tun0 | tail -1 | awk '{print $2}' | cut -d / -f1) | tee -a troubleshoot.log


## Check the kernel verison
echo -e "\n\n${ORANGE} --- Kernel Check --- ${RESET}"
echo -e "\n\n --- Kernel Check --- " >> troubleshoot.log
uname -a | tee -a troubleshoot.log

## Notice
echo -e "\n\n${GREEN}[+]${RESET} Troubleshooting script is complete."
echo -e "\n\n${GREEN}[+]${RESET} Please send the log file named ${BOLD}'troubleshoot.log'${RESET} to ${BOLD}support@cyberseclabs.co.uk${RESET}"
sleep 2s
