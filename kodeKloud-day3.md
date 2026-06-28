# Disable direct SSH root login on all app servers.
SSH server configuration is present at location : /etc/ssh/sshd_config
# set below value to no
PermitRootLogin no
# must reload/restart SSH service since it old config value loaded.
sudo systemctl restart sshd
# check status
sudo systemctl status sshd
