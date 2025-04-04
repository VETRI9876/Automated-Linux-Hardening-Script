#!/bin/bash

# Add a new user
adduser secureuser
usermod -aG sudo secureuser

# Set password policy
echo "secureuser:StrongP@ssw0rd" | chpasswd

# Secure SSH
sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh

# Enable UFW firewall
ufw allow 2222
ufw allow http
ufw allow https
ufw --force enable

# Auto updates
apt update && apt upgrade -y
apt install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades

# Rotate logs
apt install -y logrotate
logrotate --debug /etc/logrotate.conf

# Add a cron job for updates
(crontab -l 2>/dev/null; echo "0 3 * * * apt update && apt upgrade -y") | crontab -

echo "System hardening complete."
