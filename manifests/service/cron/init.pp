# pulsar::service::cron
#
# While there may not be user jobs that need to be run on the system,
# the system does have maintenance jobs that may include security
# monitoring that have to run and cron to execute them.
#
# Refer to Section(s) 6.1.1 Page(s) 138-9 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.1.1 Page(s) 121-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.1.1 Page(s) 114-5 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_info_service_cron
# Requires fact: pulsar_systemservices

class pulsar::service::cron::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::cron": }
    }
  }
}

class pulsar::service::cron::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      enable_service { "crond": }
    }
  }
}
