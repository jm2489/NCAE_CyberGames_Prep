# How to set up you Backup Server

## 1. Follow [Initial Access](https://github.com/NJITICC/NCAE_CyberGames_Prep/blob/main/docs/initial-access.md) setup on the Backup Server

---

## 2. Generate SSH Keys on the Backup Server
On the **Backup Server**, generate an SSH key pair so it can fetch configuration files:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/backup_ssh_key
```
- Press **Enter** when prompted (no passphrase needed for automation).
- This will create:
  - **Private key:** `~/.ssh/backup_ssh_key`
  - **Public key:** `~/.ssh/backup_ssh_key.pub`

---

## 3. Copy the Public Key to Each Server
For each server (**Web, FTP, DNS**), run:

```bash
ssh-copy-id -i ~/.ssh/backup_ssh_key.pub user@server-ip
```
Replace `user@server-ip` with the actual username and IP of the target server.

If `ssh-copy-id` is not available, manually append the key:

```bash
cat ~/.ssh/backup_ssh_key.pub | ssh user@server-ip "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

Ensure proper permissions:
```bash
ssh user@server-ip "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
```

---

## 4. Test SSH Access**
From the Backup Server, test logging into each server **without a password**:

```bash
ssh -i ~/.ssh/backup_ssh_key user@server-ip
```

If successful, SSH authentication is set up correctly.

---

## 5. Take a Manual Backup OR goto 6**
### ** Web Server (Apache) **
Backup configuration and website files:
```bash
rsync -avz -e "ssh -i ~/.ssh/backup_ssh_key" user@web-server:/etc/apache2 /home/backup/web_config/
rsync -avz -e "ssh -i ~/.ssh/backup_ssh_key" user@web-server:/var/www/html /home/backup/web_files/
```

### ** FTP Server **
Backup configuration and FTP root directory:
```bash
rsync -avz -e "ssh -i ~/.ssh/backup_ssh_key" user@ftp-server:/etc/vsftpd.conf /home/backup/ftp_config/
rsync -avz -e "ssh -i ~/.ssh/backup_ssh_key" user@ftp-server:/srv/ftp /home/backup/ftp_files/
```

### ** DNS Server (BIND or other DNS software) **
Backup DNS configurations:
```bash
rsync -avz -e "ssh -i ~/.ssh/backup_ssh_key" user@dns-server:/etc/bind /home/backup/dns_config/
rsync -avz -e "ssh -i ~/.ssh/backup_ssh_key" user@dns-server:/var/named /home/backup/dns_zones/
```

---

## ** 6. Automate Backups with a Cron Job**
### **1. Create the Backup Script**
On the Backup Server, create `/home/backup/backup_servers.sh` and modify the username and IPs:
```bash
#!/bin/bash
# CHANGE THESE
USERNAME="username"
WEB_SERVER_IP="192.168.1.10"
FTP_SERVER_IP="192.168.1.20"
DNS_SERVER_IP="192.168.1.30"

# Set variables
BACKUP_DIR="/home/backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOGFILE="$BACKUP_DIR/backup_log.txt"
SSH_KEY="~/.ssh/backup_ssh_key"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Web Server Backup
rsync -avz -e "ssh -i $SSH_KEY" "$USERNAME@$WEB_SERVER_IP:/etc/apache2" "$BACKUP_DIR/web_config_$TIMESTAMP"
rsync -avz -e "ssh -i $SSH_KEY" "$USERNAME@$WEB_SERVER_IP:/var/www/html" "$BACKUP_DIR/web_files_$TIMESTAMP"

# FTP Server Backup
rsync -avz -e "ssh -i $SSH_KEY" "$USERNAME@$FTP_SERVER_IP:/etc/vsftpd.conf" "$BACKUP_DIR/ftp_config_$TIMESTAMP"
rsync -avz -e "ssh -i $SSH_KEY" "$USERNAME@$FTP_SERVER_IP:/srv/ftp" "$BACKUP_DIR/ftp_files_$TIMESTAMP"

# DNS Server Backup
rsync -avz -e "ssh -i $SSH_KEY" "$USERNAME@$DNS_SERVER_IP:/etc/bind" "$BACKUP_DIR/dns_config_$TIMESTAMP"
rsync -avz -e "ssh -i $SSH_KEY" "$USERNAME@$DNS_SERVER_IP:/var/named" "$BACKUP_DIR/dns_zones_$TIMESTAMP"

# Log completion
echo "Backup completed at $TIMESTAMP" >> "$LOGFILE"
```

### **2. Make the Script Executable**
```bash
chmod +x /home/backup/backup_servers.sh
```

### **3. Add a Cron Job**
Edit the crontab:
```bash
crontab -e
```
Add the following line to run the script every 30 minutes:
```bash
*/30 * * * * /home/backup/backup_servers.sh >> /home/backup/backup_cron.log 2>&1
```

## **Final Testing**
Run the backup script manually:
```bash
/home/backup/backup_servers.sh
```
Verify:
- The script runs without errors.
- Backup files appear in `/home/backup/`.
- Cron jobs execute on schedule (`cat /home/backup/backup_cron.log`).

---

Now your **Backup Server** can securely retrieve configuration and file information from your **Web, FTP, and DNS servers** every 30 minutes! Let me know if you need any tweaks! 🚀
