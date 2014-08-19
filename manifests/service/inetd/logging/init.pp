# pulsar::service::inetd::logging
#
# The inetd process starts Internet standard services and the "tracing" feature
# can be used to log information about the source of any network connections
# seen by the daemon.
# Rather than enabling inetd tracing for all services with "inetadm -M ...",
# the administrator has the option of enabling tracing for individual services
# with "inetadm -m <svcname> tcp_trace=TRUE", where <svcname> is the name of
# the specific service that uses tracing.
# This information is logged via syslogd (1M) and is deposited by default in
# /var/adm/messages with other system log messages. If the administrator wants
# to capture this information in a separate file, simply modify /etc/syslog.conf
# to log daemon.notice to some other log file destination.
#.

# Requires fact: pulsar_syslog
# Requires fact: pulsar_inetadm_tcp_tcp_trace
# Requires fact: pulsar_inetd

# Needs fixing

class pulsar::service::inetd::logging::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::inetd::logging": }
    }
  }
}

class pulsar::service::inetd::logging::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      add_line_to_file { "LOG_FROM_REMOTE=NO": path => "syslogd" }
      if $kernelrelease =~ /9|10/ {
        if $kernelrelease =~ /10/ {
          check_exec { 'pulsar::service::inetd::logging::main::tcp_trace':
            exec  => 'inetadm -M tcp_trace=TRUE',
            check => 'inetadm -l tcp |grep "tcp_trace |grep -i "TRUE"',
            value => "TRUE",
          }
        }
        if $kernelrelease =~ /9/ {
          add_line_to_file { "ENABLE_CONNECTION_LOGGING=YES": path => "inetd" }
        }
      }
    }
  }
}
