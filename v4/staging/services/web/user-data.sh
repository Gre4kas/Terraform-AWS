#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status
exec > /var/log/user-data.log 2>&1  # Redirect output to a log file for troubleshooting

# Update and install nginx
echo "Updating package database..."
sudo apt update -y

echo "Installing nginx..."
sudo apt install -y nginx

# Modify nginx configuration to use specified server port
echo "Configuring nginx to use port ${server_port}..."
sudo sed -i "s/listen 80 default_server;/listen ${server_port} default_server;/g" /etc/nginx/sites-available/default
sudo sed -i "s/listen \\[::\\]:80 default_server;/listen \\[::\\]:${server_port} default_server;/g" /etc/nginx/sites-available/default

# Restart nginx to apply changes
echo "Restarting nginx..."
sudo systemctl restart nginx

# Fetch instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create index.html with instance details
echo "Creating index.html with instance and PostgreSQL information..."
echo "Hello, World!!!" | sudo tee /var/www/html/index.html
echo "Instance ID: $INSTANCE_ID" | sudo tee -a /var/www/html/index.html
echo "Availability Zone: $AVAILABILITY_ZONE" | sudo tee -a /var/www/html/index.html
echo "PostgreSQL address: ${postgres_address}" | sudo tee -a /var/www/html/index.html
echo "PostgreSQL port: ${postgres_port}" | sudo tee -a /var/www/html/index.html

echo "Script execution completed."
