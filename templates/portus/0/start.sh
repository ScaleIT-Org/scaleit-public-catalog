mkdir -p {certs,data}
sudo certbot certonly --agree-tos --standalone -d portus.staging.teco.edu --email admin@staging.teco.edu
cp /etc/letsencrypt/live/portus.staging.teco.edu/* certs/
