#!/bin/bash

# Set terminal text color to green
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

# Check if base58 is installed
if ! command -v base58 &> /dev/null
then
    echo -e "${GREEN}base58 is not installed. Installing base58...${RESET}"
    sudo apt-get -y install base58
fi

# Check if screen is installed
if ! command -v screen &> /dev/null
then
    echo -e "${GREEN}screen is not installed. Installing screen...${RESET}"
    sudo apt-get install -y screen
fi

# Check free RAM
free_ram=$(free -m | awk '/^Mem:/{print $4}')
if [ $free_ram -lt 1600 ]; then
    echo -e "${GREEN}Warning: Only $free_ram MB of free RAM, at least 1600 MB required.${RESET}"
    exit 1
fi

# Check free disk space
disk_usage=$(df -m / | tail -1 | awk '{print $5}' | sed 's/%//')
disk_size=$(df -m / | tail -1 | awk '{print $2}')
if [ $disk_usage -gt 70 ] || [ $disk_size -lt 20000 ]; then
    if [ $disk_usage -gt 70 ]; then
        echo -e "${GREEN}Warning: Only $disk_usage% of free disk space left on /, at least 20 GB required.${RESET}"
    fi
    if [ $disk_size -lt 20000 ]; then
        echo -e "${GREEN}Warning: Only $disk_size MB of total disk space on /, at least 20 GB required.${RESET}"
    fi
    exit 1
fi

# Check Java version
java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ $java_version < "17" ]]; then
    echo -e "${GREEN}Warning: Java version $java_version is less than 17.${RESET}. Installing Java Version 17 (openjdk-17-jre,openjdk-17-jdk).${RESET}"
	sudo apt install openjdk-17-jre
	sudo apt install openjdk-17-jdk
	sudo apt update
else
	echo -e "${GREEN} Java version: $java_version is already Installed.${RESET}"
fi

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo -e "${GREEN}jq is not installed. Installing jq...${RESET}"
    sudo apt-get install-y jq
else
	echo -e "jq is already installed.${RESET}"
fi

# Check if unzip is installed
if command -v unzip &> /dev/null
then
    echo -e "${GREEN}unzipis already installed. Version: ${RESET}"
    unzip -v
else
    echo-e "${GREEN}dos2unix and unzip is not installed. Installing unzip...${RESET}"
    sudo apt-get install -y dos2unix
    sudo apt-get install -y unzip
fi

# Check if openssl is installed
if ! command -v openssl &> /dev/null
then
    echo -e "${GREEN}openssl is not installed. Installing openssl...${RESET}"
    sudo apt-get install -y openssl
else
	echo -e "${GREEN}openssl is already installed.${RESET}"
fi

# Download the latest Krosscoin release
echo -e "${GREEN}Downloading the latest Krosscoin release...${RESET}"
if [ -f master.zip ]; then
    echo -e "${GREEN}Error: master.zip is already installed. Please remove it before running this scriptagain.${RESET}"
    exit 1
fi

# Get the latest release name from the Krosscoin repository
release_name=$(curl https://api.github.com/repos/Krosscoin/releases/releases/latest -s | jq .name -r)

# Check if the release name starts with v1
if [[ $release_name == v1* ]]; then
    # Remove the first left letter from the release name
    version=${release_name:1}
    echo -e "${GREEN}Latest Krosscoin version: $version${RESET}"

    # Check if kss-all-${version}.jar is already installed
    if [ -f kss-all-${version}.jar ]; then
        echo -e "${GREEN}Error:kss-all-${version}.jar is already installed. Please remove it before running this script again.${RESET}"
        exit 1
    fi

    # Check if releases-master folder exists
    if [ -d releases-master ]; then
        echo -e "${GREEN}releases-master folder already exists.${RESET}"
    else
        # Installing releases-master folder
        echo -e "${GREEN}Downloading master.zip and Creating releases-master folder...${RESET}"
        sudo wget https://github.com/Krosscoin/releases/archive/master.zip
		sudo unzip master.zip
		sudo rm master.zip
		
    fi

    # Install the latest Krosscoin version
    echo -e "${GREEN}Installing Krosscoin version $version...${RESET}"
    sudo wget https://github.com/Krosscoin/releases/releases/download/v${version}/kss-all-${version}.jar

    # Move the kss-all-${version}.jar file to the releases-master folder
    sudo mv kss-all-${version}.jar releases-master/
	echo -e "${GREEN}Moved kss-all-${version}.jar to releases-master Folder...${RESET}"
	cd releases-master
fi

# Delete start.bat
if [ -f start.bat ]; then
    echo -e "${GREEN}Deleting start.bat...${RESET}"
    sudo rm -rf start.bat
fi

# Get node name input
echo -e "${GREEN}Enter the Node Name: ${RESET}"
read node_name

# Update node-name in mainnet.conf
sudo sed -i "s/node-name = .*/node-name = \"$node_name\"/g" mainnet.conf

# Get seed input
echo -e "${GREEN}Enter the Wallet Seed Phrase: ${RESET}"
read seed

# Convert seed to base58
base58_seed=$(echo -n "$seed" | base58)

# Update seed in mainnet.conf
sudo sed -i "s/seed = .*/seed = \"$base58_seed\"/g" mainnet.conf

# Generate random SHA-1 hashfor password
password_hash=$(openssl rand -hex 20 | sha1sum | awk '{print $1}')

# Update password in mainnet.conf
sudo sed -i "s/password = .*/password = \"$password_hash\"/g" mainnet.conf

# Run dos2unix on mainnet.conf
sudo dos2unix mainnet.conf

# Service name (Node Service Name)
SERVICE_NAME="kss_node.service"

# Service description (replace if needed)
SERVICE_DESCRIPTION="Krosscoin Node Service"

# Create the kss service file
sudo chown -R $(whoami):$(whoami) /etc/systemd/system/
sudo cat << EOF > /etc/systemd/system/${SERVICE_NAME}
[Unit]
Description=${SERVICE_DESCRIPTION}
After=network.target

[Service]
User=$(whoami)
WorkingDirectory=$(pwd)
ExecStart=sudo java -jar kss-all-${version}.jar mainnet.conf
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo -e "${GREEN}Created ${SERVICE_DESCRIPTION}: under Directory: /etc/systemd/system/ with a name ${SERVICE_NAME}...${RESET}"
sleep 2
echo -e "${GREEN}Staring ${SERVICE_DESCRIPTION} to reload deamon and starting node...${RESET}"
sudo systemctl daemon-reload
sleep 1
sudo systemctl start kss_node.service
sleep 2
echo -e "${GREEN}Commands Lists:"
echo -e "${GREEN}Command to Check node is running in background:${RESET}sudo journalctl --follow --unit kss_node.service --lines 100"
echo -e "${GREEN}Command to Check running node status in background:${RESET}sudo systemctl status kss_node.service"
echo -e "${GREEN}Command to Stop running node in background:${RESET}sudo systemctl stop kss_node.service"
echo -e "${GREEN}Thanks for using KSS Node Services, Happy Mining...${RESET}"
exit 0
