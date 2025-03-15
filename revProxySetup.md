# Reverse Proxy Setup
## Run Status on etechacademy & discover what rev proxy you will using

```bash
systemctl status etechacademy
```

```bash
systemctl nginx 
```

```bash
systemctl status apache2
```

---

## Nginx
Recommended practice to create a custom configuration file for your new server block:

```bash
sudo vim /etc/nginx/sites-available/your_domain
```

```bash
server {
    listen 80;
    listen [::]:80;

    listen 443 ssl http2;

    server_name team4.ncaecybergames.org;

    ssl_certificate /path/to/fullchain.pem;
    ssl_certificate_key /path/to/privkey.pem;
        
    location / {
        proxy_pass 127.0.0.1:8000;
        include proxy_params;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
Replace `/path/to/fullchain.pem;` to actual file location of .pem

Enable  this configuration file by creating a link from it to the `sites-enabled` directory that Nginx reads at startup:

```bash
sudo ln -s /etc/nginx/sites-available/team4.ncaecybergames.org /etc/nginx/sites-enabled/
```

You can now test your configuration file for syntax errors:

```bash
sudo nginx -t
```

With no problems reported, restart Nginx to apply your changes:

```bash
sudo systemctl restart nginx
```

## Apache
Enable Necessary Apache Modules

```bash
sudo a2enmod proxy proxy_http
```
Modifying the Default Configuration to Enable Reverse Proxy

Open the default Apache configuration file using your preferred text editor:

```bash
sudo vim /etc/apache2/sites-available/000-default.conf
```

```bash
<VirtualHost *:80>
    ProxyPreserveHost On

    ProxyPass / http://localhost:8000/
    ProxyPassReverse / http://localhost:8000/
</VirtualHost>
<VirtualHost *:443>
    ServerName team4.ncaecybergames.org
    SSLProxyEngine On
    SSLProxyVerify require
    SSLProxyCACertificateFile /path/to/custom_cert.pem
    SSLProxyCheckPeerCN on  # or omit, default is on
    ProxyPass / https://localhost:8000/
    ProxyPassReverse / https:localhost:8000/
</VirtualHost>
```

```bash
sudo systemctl restart apache2
```