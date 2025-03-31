FROM nginx:stable

# Install necessary packages
RUN apt-get update && \
  apt-get install -y php8.1 php8.1-fpm php8.1-intl php8.1-mysql libicu-dev && \
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

# Start Nginx and PHP-FPM
CMD service php8.1-fpm start && nginx -g "daemon off;"
