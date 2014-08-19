# pulsar::service::logrotate
#
# Make sure logrotate is set up appropriately.
#
# The system includes the capability of rotating log files regularly to avoid
# filling up the system with logs or making the logs unmanageable large.
# The file /etc/logrotate.d/syslog is the configuration file used to rotate
# log files created by syslog or rsyslog. These files are rotated on a weekly
# basis via a cron job and the last 4 weeks are kept.
# By keeping the log files smaller and more manageable, a system administrator
# can easily archive these files to another system and spend less time looking
# through inordinately large log files.
#
# Refer to Section(s) 4.3 Page(s) 97 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.3 Page(s) 120-1 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 8.4 Page(s) 113-4 SLES 11 Benchmark v1.0.0
#.

# Needs code to handle updating file

class pulsar::service::logrotate::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::logrotate": }
    }
  }
}

class pulsar::service::logrotate::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'Linux' {
      $log_files   = '/var/log/messages /var/log/secure /var/log/maillog /var/log/spooler /var/log/boot.log /var/log/cron'
      $os_info     = split($kernelrelease,'.')
      $os_version  = $os_info[0]
      if $lsbdistid == 'Ubuntu' and $os_version > 12 {
        $syslog_file = "/etc/logrotate.d/rsyslog"
      }
      if $lsbdistid == 'RedHat' and $os_version > 6 {
        $syslog_file = "/etc/logrotate.d/rsyslog"
      }
      check_exec { 'logrotate':
        exec  => 'sed -i "s,.*{,$log_files{," $syslog_file',
        check => 'cat $syslog_file |grep "/var/log/secure"',
        value => "",
      }
    }
  }
}
