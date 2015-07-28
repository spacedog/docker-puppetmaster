# HEADER
FROM          abaranov/base
MAINTAINER    abaranov@linux.com

ENV           UPDATED_AT 2015-03-25

ENV           REPO_PUPPETLABS_URL http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
ENV           REPO_FOREMAN_URL    http://yum.theforeman.org/releases/latest/el6/x86_64/foreman-release.rpm

# Puppetlabs repo
RUN           rpm --quiet -Uvh ${REPO_PUPPETLABS_URL}

# Foreman repo
RUN           rpm --quiet -Uvh ${REPO_FOREMAN_URL}

# Update yum cache
RUN           yum -y -q makecache && \
              yum -y -q update && \
              yum -y -q clean all

# Install packages
RUN           yum -y -q install \
                httpd \
                mod_passenger \
                mod_ssl \
                puppetdb-terminus \
                puppet-server && \
              yum -y -q clean all

RUN           gem install hiera-eyaml
ADD           puppetmaster.conf /etc/httpd/conf.d/puppetmaster.conf

# Passenger rack
RUN           mkdir -p /etc/puppet/rack/puppetmasterd/{public,tmp}
ADD           config.ru /etc/puppet/rack/puppetmasterd/config.ru
RUN           chown puppet:puppet /etc/puppet/rack/puppetmasterd/config.ru
# Configuration files
ADD           routes.yaml /etc/puppet/routes.yaml
ADD           puppetdb.conf /etc/puppet/puppetdb.conf
ADD           external_node /etc/puppet/bin/external_node
RUN           chmod 755 /etc/puppet/bin/external_node
RUN           rm /etc/puppet/puppet.conf

# VOLUMES
VOLUME        /var/lib/puppet/ssl

# Expose ports
EXPOSE 8140

# Entry point
ENTRYPOINT ["/usr/sbin/httpd"]

# Default CMD
CMD ["-D", "FOREGROUND"]

