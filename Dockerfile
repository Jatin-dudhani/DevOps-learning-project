FROM nginx:alpine

# Remove default nginx configuration
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy hardened nginx configuration with security headers and gzip
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build artifacts to nginx document root
COPY public/ /usr/share/nginx/html/

# Expose standard web traffic port
EXPOSE 80

# Healthcheck for container orchestration and self-healing
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/healthz > /dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]