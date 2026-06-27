switch to root - sudo su -
ssh stapp03
# Create the Temporary User with an Expiration Date
sudo useradd -e 2027-03-28 -m john
-e => expiry day
-m => Automatically creates a home directory (/home/tempuser) for them.
sudo passwd ==> to create password

# to verify :
id john
output - uid=1001(john) gid=1001(john) groups=1001(john)

# another way to verify -
cd /etc
cat passwd
