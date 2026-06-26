# create a non-interactive system or service account
sudo useradd -M -s /usr/sbin/nologin service_user
-M => Tells the system not to create a home directory for the user.
-s /usr/sbin/nologin => to disable shell interection.
why ? If an application or background daemon (like Apache, Nginx, or MySQL) gets compromised by an attacker, having it run under a non-interactive user account ensures the hacker cannot easily drop into an active terminal shell to navigate your system.

# to delete user
sudo userdel -r service_user
-r => ensures that everything related to that user is deleted. 
