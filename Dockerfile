# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM dockerfile/supervisor
MAINTAINER Kevin Delfour <kevin@delfour.eu>

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y bzip2 wget apache2 sendmail smbclient \
  fontconfig-config fonts-dejavu-core ghostscript gsfonts imagemagick-common \
  libapache2-mod-php5 libcupsfilters1 libcupsimage2 libfftw3-double3 \
  libfontconfig1 libfreetype6 libgd3 libgs9 libgs9-common libicu52 libijs-0.35 \
  libjasper1 libjbig0 libjbig2dec0 libjpeg-turbo8 libjpeg8 liblcms2-2 \
  liblqr-1-0 libltdl7 libmagickcore5 libmagickwand5 libmcrypt4 libopts25 \
  libpaper-utils libpaper1 libpq5 libtiff5 libvpx1 libxpm4 lsof ntp \
  php-pear php-xml-parser php5 php5-cli php5-common php5-curl php5-gd \
  php5-imagick php5-intl php5-json php5-mcrypt php5-mysqlnd php5-pgsql \
  php5-readline php5-sqlite poppler-data psmisc ttf-dejavu-core

RUN update-rc.d sendmail defaults

# ------------------------------------------------------------------------------
# Install Owncloud
RUN curl -k https://download.owncloud.org/community/owncloud-7.0.2.tar.bz2 | tar jx -C /var/www/
RUN chown -R www-data:www-data /var/www/owncloud
RUN mkdir /var/www/owncloud/data

# ------------------------------------------------------------------------------
# Make some changes
RUN sed -i -e "s/output_buffering\s*=\s*4096/output_buffering = Off/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 4G/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 4G/g" /etc/php5/fpm/php.ini
RUN php5enmod mcrypt

RUN a2enmod ssl
RUN a2ensite default-ssl

ADD conf/owncloud /etc/apache2/sites-available/
RUN rm -f /etc/apache2/sites-enabled/000*
RUN ln -s /etc/apache2/sites-available/owncloud /etc/apache2/sites-enabled/

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose port & volumes
WORKDIR /
RUN ln -s /var/www/owncloud/data data
VOLUME /data

EXPOSE 80
EXPOSE 443

# ------------------------------------------------------------------------------
# Add supervisord conf
ADD conf/startup.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]