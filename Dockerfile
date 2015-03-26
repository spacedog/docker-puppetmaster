# HEADER
FROM          abaranov/base
MAINTAINER    abaranov@linux.com

ENV           UPDATED_AT 2015-03-25

# Puppetlabs repo
RUN           rpm --quiet -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

# Foreman repo
RUN           rpm --quiet -Uvh http://yum.theforeman.org/releases/latest/el6/x86_64/foreman-release.rpm

# Update yum cache
RUN           yum -y -q makecache && \
              yum -y -q update && \
              yum -y -q clean all

# Install packages
RUN           yum -y -q install \
                httpd \
                mod_passenger \
                puppet-server && \
              yum -y -q clean all

# Expose ports
EXPOSE 8140

# Entry point
ENTRYPOINT ["/usr/sbin/httpd"]

# Default CMD
CMD ["-D", "FOREGROUND"]

