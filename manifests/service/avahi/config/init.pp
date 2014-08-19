# pulsar::service::avahi::config
#
# The multicast Domain Name System (mDNS) is a zero configuration host name
# resolution service. It uses essentially the same programming interfaces,
# packet formats and operating semantics as the unicast Domain Name System
# (DNS) to resolve host names to IP addresses within small networks that do
# not include a local name server, but can also be used in conjunction with
# such servers.
# It is best to turn off mDNS in a server environment, but if it is used then
# the services advertised should be restricted.
#
# Refer to Section(s) 3.1.3-6 Page(s) 68-72 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

# Requires fact: pulsar_avahid

# Needs special text module to be created

class pulsar::service::avahi::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::avahi::config": }
    }
  }
}

class pulsar::service::avahi::config::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'Linux' {
      check_value { "pulsar::service::avahi::config::disable-user-service-publishing":
        path  => "avahid",
        param => "disable-user-service-publishing",
        value => "yes",
        after => "[publish]",
      }
      check_value { "pulsar::service::avahi::config::disable-publishing":
        path  => "avahid",
        param => "disable-publishing",
        value => "yes",
        after => "[publish]",
      }
      check_value { "pulsar::service::avahi::config::publish-address":
        path  => "avahid",
        param => "publish-address",
        value => "no",
        after => "[publish]",
      }
      check_value { "pulsar::service::avahi::config::publish-binfo":
        path  => "avahid",
        param => "publish-binfo",
        value => "no",
        after => "[publish]",
      }
      check_value { "pulsar::service::avahi::config::publish-workstation":
        path  => "avahid",
        param => "publish-workstation",
        value => "no",
        after => "[publish]",
      }
      check_value { "pulsar::service::avahi::config::publish-domain":
        path  => "avahid",
        param => "publish-domain",
        value => "no",
        after => "[publish]",
      }
      check_value { "pulsar::service::avahi::config::disallow-other-stacks":
        path  => "avahid",
        param => "disallow-other-stacks",
        value => "yes",
        after => "[server]",
      }
      check_value { "pulsar::service::avahi::config::check-response-ttl":
        path  => "avahid",
        param => "check-response-ttl",
        value => "yes",
        after => "[server]",
      }
    }
  }
}

# Need to add Solaris 11 equivalent
