# pulsar::service::avahi::server
#
# Avahi is a free zeroconf implementation, including a system for multicast
# DNS/DNS-SD service discovery. Avahi allows programs to publish and discover
# services and hosts running on a local network with no specific configuration.
# For example, a user can plug a computer into a network and Avahi
# automatically finds printers to print to, files to look at and people to
# talk to, as well as network services running on the machine.
#
# Refer to Section(s) 3.3 Page(s) 60 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.3 Page(s) 67 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.3 Page(s) 63 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.2 Page(s) 52-3 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::avahi::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::avahi::server": }
    }
  }
}

class pulsar::service::avahi::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      $avahi_services = [ 'avahi', 'avahi-autoipd', 'avahi-daemon', 'avahi-dnsconfd' ]
      disable_service { $avahi_services: }
    }
  }
}
