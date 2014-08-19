# pulsar::service::cron::perms
#
# Make sure system cron entries are only viewable by system accounts.
# Viewing cron entries may provide vectors of attack around temporary
# file creation and race conditions.
#
# Refer to Section(s) 6.1.2-9 Page(s) 119-125 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.1.2-9 Page(s) 138-9 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.1.2-9 Page(s) 122-8 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.1.2-8 Page(s) 115-9 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_perms_etc_crontab
# Requires fact: pulsar_perms_var_spool_cron
# Requires fact: pulsar_perms_etc_cron.daily
# Requires fact: pulsar_perms_etc_cron.weekly
# Requires fact: pulsar_perms_etc_cron.monthly
# Requires fact: pulsar_perms_etc_cron.hourly
# Requires fact: pulsar_perms_etc_anacrontab

class pulsar::service::cron::perms::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::cron::perms": }
    }
  }
}

class pulsar::service::cron::perms::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'Linux' {
      check_file_perms { '/etc/crontab':
        owner => 'root',
        group => 'root',
        mode  => '0640',
      }
      check_file_perms { '/etc/anacrontab':
        owner => 'root',
        group => 'root',
        mode  => '0640',
      }
      check_crondir_perms { "/var/spool/cron": }
      check_crondir_perms { "/etc/cron.daily": }
      check_crondir_perms { "/etc/cron.weekly": }
      check_crondir_perms { "/etc/cron.mounthly": }
      check_crondir_perms { "/etc/cron.hourly": }
    }
  }
}
