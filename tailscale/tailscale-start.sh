#!/bin/sh

# Start tailscaled daemon
tailscaled &

sleep 3

# Start tailscale and authenticate (remove --auth-key after first login)
tailscale up --accept-routes --accept-dns --advertise-exit-node

exit 0
