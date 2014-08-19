# pulsar::service::cron::logging
#
# Setting the CRONLOG parameter to YES in the /etc/default/cron file causes
# information to be logged for every cron job that gets executed on the system.
# This setting is the default for Solaris.
# A common attack vector is for programs that are run out of cron to be
# subverted to execute commands as the owner of the cron job. Log data on
# commands that are executed out of cron can be found in the /var/cron/log file.
# Review this file on a regular basis.
#
# Refer to Section(s) 4.7 Page(s) 71 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_cron
# Requires fact: pulsar_perms_var_cron_log

class pulsar::service::cron::logging::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::cron::logging": }
    }
  }
}

class pulsar::service::cron::logging::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease == '5.10' {
        add_line_to_file { "CRONLOG=YES": path => "cron" }
      }
      check_perms { '/var/cron/log':
        owner => 'root',
        group => 'root',
        mode  => '0644',
      }
    }
  }
}
