FROM nginx:stable

# Install prerequisites and add PHP repository
RUN apt-get update && apt-get install -y \
  software-properties-common \
  ca-certificates \
  lsb-release \
  apt-transport-https \
  wget \
  gnupg2 && \
  wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Install PHP and required extensions
RUN apt-get update && \
  apt-get install -y \
  php8.1 \
  php8.1-fpm \
  php8.1-intl \
  php8.1-mysql \
  libicu-dev && \
  rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.1/fpm/php.ini

# Create default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration
COPY default.conf /etc/nginx/conf.d/

# Add your PHP application
COPY app /var/www/html/

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start Nginx and PHP-FPM (using array format as recommended)
CMD ["sh", "-c", "service php8.1-fpm start && nginx -g 'daemon off;'"]