#!/bin/bash
# Userdata task 17

# Install SSM agent
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

# Install nginx
sudo yum install -y nginx

# Create html page
echo "<html><body><h1>Hello, Camp 2023!</h1></body></html>" > /usr/share/nginx/html/index.html

# Start services
sudo systemctl start amazon-ssm-agent.service
sudo systemctl start nginx.service
