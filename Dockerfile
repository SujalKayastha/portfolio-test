FROM nginx:alpine

# Remove default page
RUN rm -rf /usr/share/nginx/html/*

# Copy portfolio files
COPY src/ /usr/share/nginx/html/

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 🔥 FIX PERMISSIONS FOR ALL FILES (not just assets)
RUN find /usr/share/nginx/html -type f -exec chmod 644 {} \; \
    && find /usr/share/nginx/html -type d -exec chmod 755 {} \; \
    && chown -R nginx:nginx /usr/share/nginx/html/

# Pre-create directories nginx needs
RUN mkdir -p /var/cache/nginx/client_temp \
             /var/cache/nginx/proxy_temp \
             /var/cache/nginx/fastcgi_temp \
             /var/log/nginx \
             /var/run/nginx \
             /tmp/nginx \
             /etc/nginx/temp \
 && chown -R nginx:nginx /var/cache/nginx /var/log/nginx /var/run/nginx /tmp/nginx /etc/nginx/temp \
 && chmod -R 755 /var/cache/nginx /var/log/nginx /var/run/nginx /tmp/nginx /etc/nginx/temp

# Disable the ipv6 auto-config script that modifies read-only FS
RUN chmod -x /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh

EXPOSE 80

# Run as nginx user (UID 101)
USER nginx

CMD ["nginx", "-g", "daemon off;"]
