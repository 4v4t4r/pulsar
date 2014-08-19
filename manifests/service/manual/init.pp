# pulsar::service::manual
#
# AIX:
#
# httpdlite is the Lite NetQuestion Web server software for online
# documentation. It is recommended that this software is disabled,
# unless it is required in the environment.
#
# Refer to Section(s) 2.12.4 Page(s) 209 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_inittabservices

class pulsar::service::manual::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /AIX|SunOS/ {
      init_message { "pulsar::service::manual": }
    }
  }
}

class pulsar::service::manual::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /AIX|SunOS/ {
      if $kernel == "AIX" {
        disable_inittab { "httpdlite": }
      }
      if $kernel == "SunOS" {
        disable_service { "ab2mgr": }
      }
    }
  }
}
