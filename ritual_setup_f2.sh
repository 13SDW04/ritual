#!/bin/bash

# Create and navigate to the foundry directory
mkdir -p ~/foundry
cd ~/foundry

# Install Foundry
curl -L https://foundry.paradigm.xyz | bash

# Update environment
source ~/.bashrc
foundryup

# Remove old library and install forge-std
rm -rf projects/hello-world/contracts/lib/forge-std
forge install --no-commit foundry-rs/forge-std

# Navigate to contract directory and remove old forge-std
cd ~/infernet-container-starter/projects/hello-world/contracts
rm -rf lib/forge-std

# Install forge-std
forge install --no-commit foundry-rs/forge-std

# List installed forge-std
ls lib/forge-std

# Run foundryup
foundryup

# Remove old infernet-sdk and install the new one
cd ~/infernet-container-starter/projects/hello-world/contracts
rm -rf lib/infernet-sdk
forge install --no-commit ritual-net/infernet-sdk

# List installed infernet-sdk
ls lib/infernet-sdk

# Deploy contracts
cd ~/infernet-container-starter
project=hello-world make deploy-contracts