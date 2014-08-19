# pulsar::os::debug
#
# Connections to server should be logged so they can be audited in the event
# of and attack.
#.

# Requires fact: pulsar_info_os_debug
# Requires fact: pulsar_logadm_var_adm_loginlog

# Needs fixing

class pulsar::os::debug::init {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::os::debug": }
    }
  }
}

class pulsar::os::debug::main {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        check_exec { 'pulsar::os::debug::debug_logging':
          exec  => 'logadm -w daemon.debug -C 13 -a "pkill -HUP syslogd" /var/adm/loginlog',
          check => 'logadm -V |grep -v "^#" |grep "daemon.debug"',
          value => 'daemon.debug',
        }
      }
    }
  }
}
