# pulsar::service::power
#
# Solaris:
#
# The settings in /etc/default/power control which users have access to the
# configuration settings for the system power management and checkpoint and
# resume features. By setting both values to -, configuration changes are
# restricted to only the root user.
#
# AIX:
#
# The recommendation is to disable pmd. This is the power management service
# that turns the machine off if it has been idle for a specific amount of time.
#
# Refer to Section(s) 2.12.5 Page(s) 209-210 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 10.1 Page(s) 91-2 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 10.3 Page(s) 139 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_power
# Requires fact: pulsar_inittabservices
# Requires fact: pulsar_systemservices

class pulsar::service::power::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /AIX|SunOS/ {
      init_message { "pulsar::service::power": }
    }
  }
}

class pulsar::service::power::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /AIX|SunOS/ {
      if $kernel == "AIX" {
        disable_inittab { "pmd": }
      }
      if $kernel == "Linux" {
        disable_service { "apmd": }
      }
      if $kernel == "SunOS" {
        if $kernelrelease == "5.10" {
          add_line_to_file { "PMCHANGEPERM=-": path => "power" }
          add_line_to_file { "CPRCHANGEPERM=-": path => "power" }
        }
        if $kernelrelease == "5.10" {
          check_poweradm { "suspend-enable": value => "false" }
        }
      }
    }
  }
}
