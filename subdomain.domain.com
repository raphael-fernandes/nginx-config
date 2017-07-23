# HTTP SERVER REDIRECTING TO HTTPS SERVER
server {
    listen          80;
    listen          [::]:80;

    server_name     subdomain.domain.com;

    return 301 https://$server_name$request_uri;

    location / {		
	    proxy_pass          http://127.0.0.1:3000/;
	    proxy_http_version  1.1;
	    proxy_set_header    Upgrade $http_upgrade;
	    proxy_set_header    Connection 'upgrade';
        proxy_set_header    HOST $host;
	    proxy_cache_bypass  $http_upgrade;            
	}
}


# HTTPS SERVER
server {
	listen                  443 ssl;
	listen                  [::]:443 ssl;

	server_name             subdomain.domain.com;
	
    # PUBLIC FOLDER PATH
	root                    /path/to/the/public/folder;

    # CERTIFICATE PATH
    ssl_certificate         /path/to/the/certificate/cert.pem;
    ssl_certificate_key     /path/to/the/certificate/key/key.pem;

    # SSL PARAMS (https://cipherli.st/)
    ssl_protocols TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off; # Requires nginx >= 1.5.9
    ssl_stapling on; # Requires nginx >= 1.3.7
    ssl_stapling_verify on; # Requires nginx => 1.3.7
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;

    # openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
    ssl_dhparam /etc/ssl/certs/dhparam.pem;

	location / {
	    proxy_pass          https://127.0.0.1:3443/;
	    proxy_http_version  1.1;
	    proxy_set_header    Upgrade $http_upgrade;
	    proxy_set_header    Connection 'upgrade';
        proxy_set_header    HOST $host;
	    proxy_cache_bypass  $http_upgrade;            
	}
}
