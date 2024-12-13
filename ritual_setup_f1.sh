sudo apt install docker.io -y

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Docker Compose CLI Plugin
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose

# Make the plugin executable
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# Verify Docker Compose installation
docker compose version

# Add the user to Docker group
sudo usermod -aG docker $USER

# Reboot the system to apply the changes
echo "You will be logged out, and the system will reboot. Please log back in after reboot."
sudo reboot

# After reboot, verify Docker installation
docker run hello-world

# Clone the repository
git clone https://github.com/ritual-net/infernet-container-starter
cd infernet-container-starter

# Start a screen session
screen -S ritual

# Deploy the container
# Press CTRL + A + D to detach from the screen session
project=hello-world make deploy-container