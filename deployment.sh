#!/bin/bash

# #!/bin/bash
# Shebang line.
# Tells Linux to execute this script using the Bash shell.
# /bin/bash is the path of the bash interpreter.

# Application/service name managed by systemd.
# This variable is reused later to avoid hardcoding values multiple times.
APP_NAME="payment-service"

# Directory where the application JAR file is deployed.
# Typically used in production servers for Java applications.
DEPLOY_DIR="/opt/apps/payment"

# Directory where backups of old builds are stored before deployment.
# Helps in rollback if deployment fails.
BACKUP_DIR="/backup/payment"

# Path of newly downloaded/generated application build.
# Usually copied from:
# - Jenkins workspace
# - GitLab CI artifact
# - Nexus/Artifactory download
# - Packer build
NEW_BUILD="/tmp/payment-service.jar"

# DATE variable stores current timestamp.
# $(...) -> command substitution.
# Executes command inside brackets and stores output in variable.
#
# date -> Linux command used to display/manipulate system date.
#
# +%F-%H%M formatting:
# %F  -> YYYY-MM-DD
# %H  -> Hour (24-hour format)
# %M  -> Minutes
#
# Example output:
# 2026-05-16-1830
#
# Useful for:
# - unique backup names
# - deployment tracking
# - log naming
DATE=$(date +%F-%H%M)

# Display message on terminal.
# echo -> prints text/output to console.
echo "Stopping application..."

# systemctl -> systemd service management command.
#
# stop -> stops running service gracefully.
#
# $APP_NAME expands to:
# payment-service
#
# Actual command executed:
# systemctl stop payment-service
#
# Why stop service?
# To avoid:
# - file corruption
# - partial deployment
# - locked JAR files
# - inconsistent runtime state
systemctl stop $APP_NAME

# Inform user/script logs that backup process has started.
echo "Taking backup..."

# mkdir -> create directory command.
#
# -p option:
# Creates parent directories if they do not exist.
# Prevents error if directory already exists.
#
# Example:
# mkdir -p /backup/payment
#
# Real DevOps usage:
# Used heavily in automation scripts to ensure paths exist safely.
mkdir -p $BACKUP_DIR

# cp -> copy command.
#
# Source:
# Existing deployed JAR file.
#
# Destination:
# Backup location with timestamp appended.
#
# Example generated path:
# /backup/payment/payment-service.jar-2026-05-16-1830
#
# Why backup before deployment?
# Enables quick rollback if new deployment fails.
#
# "\" indicates line continuation in shell scripting.
# Allows writing long command across multiple lines for readability.
cp $DEPLOY_DIR/payment-service.jar \
   $BACKUP_DIR/payment-service.jar-$DATE

# Inform deployment phase started.
echo "Deploying new build..."

# Copy new application build to deployment directory.
#
# Source:
# /tmp/payment-service.jar
#
# Destination:
# /opt/apps/payment/payment-service.jar
#
# Existing file gets overwritten.
#
# Real-world note:
# Usually this build comes from CI/CD pipeline artifact.
cp $NEW_BUILD $DEPLOY_DIR/payment-service.jar

# Inform that service startup is beginning.
echo "Starting service..."

# Start application service using systemd.
#
# systemctl start payment-service
#
# This launches application process in background.
#
# In production:
# systemd handles:
# - process management
# - restart policies
# - logging
# - dependency management
systemctl start $APP_NAME

# Inform health verification step started.
echo "Checking health..."

# sleep command pauses script execution.
#
# sleep 10
# waits for 10 seconds.
#
# Why needed?
# Application may take time to:
# - initialize JVM
# - bind ports
# - establish DB connections
# - load configs
#
# Without sleep:
# health/status check may fail too early.
sleep 10

# Check service status after deployment.
#
# systemctl status -> displays:
# - running state
# - PID
# - logs
# - recent errors
#
# --no-pager option:
# Prevents opening output in interactive pager like "less".
#
# Useful in:
# - CI/CD pipelines
# - Jenkins logs
# - automation scripts
# because script output becomes directly visible.
systemctl status $APP_NAME --no-pager

# Final success message.
echo "Deployment completed."
