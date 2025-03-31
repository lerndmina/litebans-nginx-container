FROM nginx:stable

# Install PHP and required extensions
RUN apt-get update && \
  apt-get install -y lsb-release apt-transport-https ca-certificates wget && \
  wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
  apt-get update && \
  apt-get install -y php8.1 php8.1-fpm php8.1-intl php8.1-mysql libicu-dev && \
  rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.1/fpm/php.ini

# Set up Nginx to use PHP-FPM
COPY default.conf /etc/nginx/conf.d/default.conf

# Set the web server's document root
ENV NGINX_DOCUMENT_ROOT=/var/www/html

# Clean up the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Start Nginx and PHP-FPM
CMD service php8.1-fpm start && nginx -g "daemon off;"
