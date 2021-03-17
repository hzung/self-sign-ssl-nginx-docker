FROM alpine
# RUN
RUN apk add nginx; \
  apk add openssl; \
  openssl req \
            -x509 \
            -nodes \
            -days 365 \
            -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" \
            -addext "subjectAltName=DNS:localhost" \
            -newkey rsa:2048 \
            -keyout /etc/ssl/private/nginx-selfsigned.key \
            -out /etc/ssl/certs/nginx-selfsigned.crt; \
  mkdir /run/nginx

WORKDIR /var/www/localhost/htdocs

# ENTRYPOINT
COPY $PWD/config/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]

# EXPOSE PORTS
EXPOSE 80
EXPOSE 443

# RUN COMMAND
CMD ["/bin/sh", "-c", "nginx -g 'daemon off;'; nginx -s reload;"]