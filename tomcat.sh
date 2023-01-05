#! /bin/bash

# URL for the Apache Tomcat binary distribution
TOMURL="https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz"

# Install OpenJDK and other necessary packages
yum install java-1.8.0-openjdk -y
yum install git maven wget -y

# Change to the /tmp directory
cd /tmp/

# Download the Tomcat binary distribution
wget $TOMURL -O tomcatbin.tar.gz

# Extract the Tomcat binary distribution
EXTOUT=`tar xzvf tomcatbin.tar.gz`

# Get the directory name of the extracted Tomcat distribution
TOMDIR=`echo $EXTOUT | cut -d '/' -f1`

# Create a new user for Tomcat
useradd --shell /sbin/nologin tomcat

# Copy the extracted Tomcat distribution to the /usr/local/tomcat8 directory
rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat8/

# Change the ownership of the /usr/local/tomcat8 directory to the tomcat user and group
chown -R tomcat.tomcat /usr/local/tomcat8

# Remove the tomcat.service file if it exists
rm -rf /etc/systemd/system/tomcat.service

# Create a new tomcat.service file
cat <<EOT>> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]

# Set the user and group to run Tomcat as
User=tomcat
Group=tomcat

# Set the working directory for Tomcat
WorkingDirectory=/usr/local/tomcat8

# Set the JAVA_HOME environment variable
#Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre

# Set the CATALINA_PID environment variable
Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid

# Set the CATALINA_HOME and CATALINE_BASE environment variables
Environment=CATALINA_HOME=/usr/local/tomcat8
Environment=CATALINE_BASE=/usr/local/tomcat8

# Set the command to start Tomcat
ExecStart=/usr/local/tomcat8/bin/catalina.sh run

# Set the command to stop Tomcat
ExecStop=/usr/local/tomcat8/bin/shutdown.sh


# Set the time to wait before restarting Tomcat on failure
RestartSec=10

# Set the service to restart always
Restart=always

[Install]
WantedBy=multi-user.target

EOT

# Reload the system daemon
systemctl daemon-reload

# Start Tomcat
systemctl start tomcat

# Enable Tomcat to start on boot
systemctl enable tomcat
