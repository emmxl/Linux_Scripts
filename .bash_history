vi system_monitor.sh
ls 
sudo nano /path/to/system_monitor.sh
ls
chmod +x system_monitor.sh 
ls
sudo ./system_monitor.sh 
cd ..
ls
cd var
ls
cd log
ls
monitor,log
cat monitor.log 
cd ..
whoami
cd ec2-user
cd .
cd ..
exit
ls
ls -la
vi setup_apache.sh
chmod +x setup_apache.sh 
ls
sudo ./setup_apache.sh 
systemctl status httpd
ls
vi setup_apache.sh 
ls
sudo ./setup_apache.sh 
ls
vi setup_apache.sh 
ls
sudo ./setup_apache.sh 
ls
ls -la
cd var/log/setup_apache.sh
cd ..
ls
cd ..
ls
cd var
ls
cd log
ls
cd apache_setup.log
cat apache_setup.log 
ls
crontab -e
crontab -l
sudo yum update
sudo yum install cronie -y
sudo systemctl enable crond
sudo systemctl start crond
crontab -l
crontab -e
crontab -l
pws
pwd
crontab -e
crontab -l
grep CRON /var/log/syslog
sudo grep CRON /var/log/syslog
java -version
sudo yum install java-11-openjdk-devel -y
sudo yum update -y
sudo amazon-linux-extras enable java-openjdk11
 amazon-linux-extras enable java-openjdk11
sudo yum amazon-linux-extras enable java-openjdk11
sudo yum install amazon-linux-extras enable java-openjdk11
sudo yum install -y java-11-openjdk-devel
yum install -y java-11-openjdk-devel
sudo yum install -y java-11-openjdk-devel
wget https://download.oracle.com/java/11/latest/jdk-11_linux-x64_bin.rpm
sudo amazon-linux-extras enable java-openjdk11
sudo yum install -y java-11-openjdk-devel
sudo yum update -y
yum search java | grep jdk
sudo yum install -y java
java -version
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which java)))))
echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
source ~/.bashrc
java -version
vi deploy_app.sh
chmod +x deploy_app.sh 
sudo ./deploy_app.sh 
ls
cd app
ls
cat app_output.log 
ls -la
cd ..
ls -la
ls /home/ec2-user/app
java -version
which java
cd /usr/bin/java
sudo /usr/bin/java
sudo cd /usr/bin/java
ls 
vi deploy_app.sh 
sudo ./deploy_app.sh 
vi deploy_app.sh 
sudo ./deploy_app.sh 
vi deploy_app.sh 
sudo ./deploy_app.sh 
vi app.java
sudo ./deploy_app.sh 
vi deploy_app.sh 
sudo ./deploy_app.sh 
javac -version
sudo amazon-linux-extras enable java-openjdk11
sudo amazon-linux-extras enable java-openjdk
sudo yum amazon-linux-extras enable java-openjdk
yum install
sudo yum update
sudo yum install -y java-1.8.0-openjdk-devel
javac -version
java -version
which javac
~/.bashrc
sudo ~/.bashrc
nano ~/.bashrc
source ~/.bashrc
sudo ./deploy_app.sh 
vi ~/.bashr
nano ~/.bashrc
javac
java -version
which javac
.
vi backup.sh
vi restore.sh
#!/bin/bash
# Set the backup file and restore directory
BACKUP_FILE="/backup/backup_$(date +%Y%m%d).tar.gz"
RESTORE_DIR="/restore_test"
# Create the restore directory if it doesn't exist
mkdir -p "$RESTORE_DIR"
# Extract the backup into the restore directory
echo "Restoring the backup to $RESTORE_DIR"
tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"
# Verify the restored files
echo "Verifying the restored files..."
if [ "$(diff -r /etc/ "$RESTORE_DIR")" ]; then   echo "The restored files do not match the original structure.";   exit 1; else   echo "

crontab -e
chmod +x backup.sh
chmod +x restore.sh
ld
ls
./backup.sh
sudo ./backup.sh
sudo ./restore.sh
ls /backup
grep CRON /var/log/syslog
sudo grep CRON /var/log/syslog
clear
ls
crontab -l
cd ..
ls
cd ec2-user/
ls
cd ..
ls
cd var/log
ls
cat monitor.log 
cat apache_setup.log 
cd ..
exit
ls
clear
crontab -l
ls
vi app.java
sudo ./deploy_app.sh 
java -version
vi deploy_app.sh 
javac -version
sudo javac -version
sudo yum javac -version
ls /usr/lib/jvm/java-23-openjdk/bin/
ls -la 
cd ..
ls -la 
cd ..
ls -la
vi  ~/.bashrc
sudo yum install -y java-17-openjdk-devel
history
sudo yum remove java*
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto-devel
java -version
javac -version
sudo ./deploy_app.sh 
ls
cd ..
ls
cd home
ls
cd ec2-user/
ls
sudo ./deploy_app.sh 
clear
ls 
cd app
ls
cat app_output.log 
cd 
ls
sudo ./setup_apache.sh 
