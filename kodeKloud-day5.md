# SELinux (Security-Enhanced Linux)
With SELinux, the web server process is "confined." 
Even if an attacker compromises the web server, they are tightly restricted to the specific directories 
and system calls defined by the SELinux policy, 
preventing them from spreading the attack to the rest of the machine.

# SELinux mode:
- enforcing - The default, secure mode. SELinux actively enforces policies, blocks unauthorized actions, and logs them.
- permissive - SELinux is "on" but does not block anything. It simply logs what would have been blocked. 
  This is heavily used by administrators for troubleshooting.
- disabled - SELinux is completely turned off. It provides no security protection and generates no logs.

getenforce - command displays - Displays the current operating mode.
setenforce 0 / setenforce 1 - Temporarily switches between Permissive (0) and Enforcing (1) modes.
eg: setenforce 0 - changes from enforcing => permissive but it is changed back to enforcing once machine is rebooted.

# what if we want to make a permanent change ?
/etc/selinux/config - The main configuration file used to set the default SELinux mode on boot.
change value to SELINUX=enforcing to SELINUX=disabled

# how to get the OS system details ?
cat /etc/os-release

# Task 1 - Install the required SELinux packages.
it is centos
sudo dnf install -y policycoreutils selinux-policy selinux-policy-targeted

# task 2 - Permanently disable SELinux for the time being; it will be re-enabled after necessary configuration changes.
for permanent change, we will need to make change in config file at /ect/selinux/config

# task 3 -  No need to reboot the server, as a scheduled maintenance reboot is already planned for tonight.

