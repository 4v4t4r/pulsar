# pulsar::service::syslog::config
#
# By default, Solaris systems do not capture logging information that is sent
# to the LOG_AUTH facility.
# A great deal of important security-related information is sent via the
# LOG_AUTH facility (e.g., successful and failed su attempts, failed login
# attempts, root login attempts, etc.).
#
# Refer to Section(s) 3.4 Page(s) 10 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.1.1 Page(s) 104-5 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

# Requires fact: pulsar_syslog

class pulsar::service::syslog::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux|FreeBSD|SunOS/ {
      init_message { "pulsar::service::syslog::config": }
    }
  }
}

class pulsar::service::syslog::config::main {
  if $pulsar_modules =~ /test|full/ {
    if $kernel =~ /Linux|FreeBSD|SunOS/ {
      $lines = [
        'auth,user.*\t/var/log/messages',
        'kern.*\t/var/log/kern.log',
        'daemon.*\t/var/log/daemon.log',
        'syslog.*\t/var/log/syslog',
        'lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*\t/var/log/unused.log'
      ]
      if $kernel =~ /SunOS|FreeBSD/ {
        add_line_to_file { $lines: path => "/etc/syslog.conf" }
      }
      if $kernel =~ /Linux/ {
        if $lsbdistid =~ /CentOS|Red|SuSE/ {
          if $lsbmajdistrelease > 5 {
            add_line_to_file { $lines: path => "/etc/rsyslog.conf" }
          }
          else {
            add_line_to_file { $lines: path => "/etc/syslog.conf" }
          }
        }
      }
      else {
        if $lsbdistid =~ /Debian|Ubuntu/ {
          add_line_to_file { $lines: path => "/etc/rsyslog.conf" }
        }
      }
    }
  }
}
