#!/bin/bash

# Function to check the status of the Solana service
check_solana_status() {
    systemctl status solana | grep "Active:" | awk '{print $2}'
}

# Attempt to check and ensure the Solana service is active
attempt=1
max_attempts=3

while [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts: Checking Solana node status..."
    status=$(check_solana_status)
    
    if [ "$status" == "active" ]; then
        echo "The Solana node is successfully running with an active status."
        exit 0
    else
        echo "Error: The Solana node is not active. Attempting to restart the service..."
        systemctl restart solana
        echo "The Solana service has been restarted. Verifying status..."
        sleep 5  # Wait for a few seconds to let the service restart
        status=$(check_solana_status)
        
        if [ "$status" == "active" ]; then
            echo "The Solana node is now active after the restart."
            exit 0
        else
            echo "Error: The Solana node is still not active after the restart."
        fi
    fi
    
    ((attempt++))
done

echo "Critical Error: The Solana node could not be activated after $max_attempts attempts."
exit 1
