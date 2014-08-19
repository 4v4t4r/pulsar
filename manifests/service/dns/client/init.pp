# pulsar::service::dns::client
#
# Nscd is a daemon that provides a cache for the most common name service
# requests. The default configuration file, /etc/nscd.conf, determines the
# behavior of the cache daemon.
# Unless required disable Name Server Caching Daemon as it can result in
# stale or incorrect DNS information being cached by the system.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::dns::client::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::dns::client": }
    }
  }
}

class pulsar::service::dns::client::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      disable_service { "nscd": }
    }
    if $kernel == "SunOS" and $kernelrelease =~ /6|7|8|9/ {
      disable_service { "nscd": }
    }
  }
}
