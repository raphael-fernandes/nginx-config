# Nginx config files to create subdomains and redirect http to https

## Steps
1. Rename the file to your subdomain and domain name
2. Change the content to match your settings (paths, IP, port, subdomain, domain, ...)
3. Place it inside: ```/etc/nginx/sites-available```
4. Create a symlink (```ln -s```) to it in: ```/etc/nginx/sites-enabled```
5. Create *dhparam*: ```sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048```
6. Check if any SSL is duplicated in nginx.conf. Remove these from you file.
7. Run: ```sudo nginx -t```. This command check for errors in nginx config files.
8. Restart nginx: ```sudo systemctl restart nginx```
9. For localhost tests: you have to set the domain/subdomain in: ```/etc/hosts```. e.g. ```127.0.0.1 subdomain.domain.com```

## Readings:
- (https://cipherli.st/)[https://cipherli.st/]
- [https://michael.lustfield.net/nginx/getting-a-perfect-ssl-labs-score](https://michael.lustfield.net/nginx/getting-a-perfect-ssl-labs-score)