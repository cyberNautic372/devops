#!/bin/bash
# Make forwarding permanent
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Clear old duplicates
sudo iptables -t nat -F
sudo iptables -F

# Required routing rules
sudo iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
sudo iptables -A FORWARD -i tailscale0 -o eno1 -j ACCEPT
sudo iptables -A FORWARD -o tailscale0 -j ACCEPT
sudo iptables -A FORWARD -i tailscale0 -o eno1 -p udp --dport 53 -j ACCEPT
sudo iptables -A FORWARD -i tailscale0 -o eno1 -p tcp --dport 53 -j ACCEPT
sudo iptables -A FORWARD -i eno1 -o tailscale0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Save forever (survives reboot)
sudo apt install -y iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload

echo "🔥 Routing + Exit Node ready forever. Reboot or restart docker."
