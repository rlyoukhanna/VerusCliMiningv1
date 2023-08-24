#!/bin/sh

# Update package information and upgrade existing packages
sudo apt-get -y update
sudo apt-get -y upgrade

# Install required packages
sudo apt-get -y install libcurl4-openssl-dev libjansson-dev libomp-dev git screen nano jq wget

# Download and install specific version of libssl1.1 package
wget http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_arm64.deb
sudo dpkg -i libssl1.1_1.1.0g-2ubuntu4_arm64.deb
rm libssl1.1_1.1.0g-2ubuntu4_arm64.deb

# Create a directory for ccminer and navigate into it
mkdir ~/ccminer
cd ~/ccminer

# Fetch the latest release information from GitHub and extract download URL and filename
GITHUB_RELEASE_JSON=$(curl --silent "https://api.github.com/repos/Oink70/Android-Mining/releases?per_page=1" | jq -c '[.[] | del (.body)]')
GITHUB_DOWNLOAD_URL=$(echo "$GITHUB_RELEASE_JSON" | jq -r ".[0].assets | .[] | .browser_download_url")
GITHUB_DOWNLOAD_NAME=$(echo "$GITHUB_RELEASE_JSON" | jq -r ".[0].assets | .[] | .name")

# Download the ccminer binary and a sample configuration file
echo "Downloading latest release: $GITHUB_DOWNLOAD_NAME"
wget "$GITHUB_DOWNLOAD_URL" -O ~/ccminer/ccminer
wget https://raw.githubusercontent.com/rlyoukhanna/VerusCliMiningv1/main/config.json -O ~/ccminer/config.json

# Make the ccminer binary executable
chmod +x ~/ccminer/ccminer

# Create a start script for ccminer
cat << EOF > ~/ccminer/start.sh
#!/bin/sh
~/ccminer/ccminer -c ~/ccminer/config.json
EOF
chmod +x ~/ccminer/start.sh

# Display setup instructions
echo "Setup is nearly complete."
echo "Edit the config with \"nano ~/ccminer/config.json\""
echo "Go to line 15 and change your worker name."
echo "Use \"<CTRL>-x\" to exit and respond with \"y\" on the question to save and \"enter\"."
echo "Start the miner with \"cd ~/ccminer; ./start.sh\"."
