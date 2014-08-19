# pulsar::service::syslog::server
#
# Linux and Solaris 11 (to be added):
#
# The rsyslog package is a third party package that provides many enhancements
# to syslog, such as multi-threading, TCP communication, message filtering and
# data base support.
#
# FreeBSD
#
# Capture ftpd and inetd information
# FreeBSD 5.X has this feature enabled by default. Although the log file is
# called debug.log.
#
# Refer to Section(s) 4.1.1-8 Page(s) 71-76 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.2.1-8 Page(s) 108-113 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 5.1.1-8 Page(s) 94-9 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 8.2.1-8 Page(s) 106-111 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.1 Page(s) 18 CIS FreeBSD Benchmark v1.0.5
#.

# Requires fact: pulsar_perms_etc_rsyslog.conf
# Requires fact: pulsar_perms_etc_syslog.conf
# Requires fact: pulsar_perms_var_log_daemon.log
# Requires fact: pulsar_rcconf
# Requires fact: pulsar_systemservices

# This code needs cleaning up


class pulsar::service::syslog::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux|FreeBSD|SunOS/ {
      init_message { "pulsar::service::syslog::server": }
    }
  }
}

class pulsar::service::syslog::server::pre {
  if $pulsar_modules =~ /test|full/ {
    if $kernel =~ /Linux|FreeBSD|SunOS/ {
      $file_list = [ '/var/log/message', '/var/log/kern.log',
                     '/var/log/syslog', '/var/log/unused.log' ]
      check_file_exists { $file_list: }
      if $kernel == "Linux" {
        if $lsbdistid =~ /CentOS|Red|SuSE/ {
          if $lsbmajdistrelease > 5 {
            install_package { "rsyslog": }
            disable_service { "syslog": }
          }
        }
        else {
          if $lsbdistid =~ /Debian|Ubuntu/ {
            install_package { "rsyslog": }
          }
        }
      }
    }
  }
}

class pulsar::service::syslog::server::main {
  if $pulsar_modules =~ /test|full/ {
    if $kernel =~ /Linux|FreeBSD|SunOS/ {
      if $kernel == "SunOS" {
        # Need to check proper service names
        if $kernelrelease == "5.11" {
          enable_service { "rsyslog": }
        }
        else {
          enable_service { "syslog": }
        }
      }
      if $kernel =~ /FreeBSD/ {
        check_file_perms { "/var/log/daemon.log":
          owner => "root",
          group => "wheel",
          mode  => "0600",
        }
        add_line_to_file { "syslog_flags = -s": path => "rc" }
      }
      if $kernel =~ /Linux/ {
        if $lsbdistid =~ /CentOS|Red|SuSE/ {
          if $lsbmajdistrelease > 5 {
            check_file_perms { "/etc/rsyslog.conf":
              owner => "root",
              group => "root",
              mode  => "0600",
            }
            enable_service { "rsyslog": }
          }
          else {
            enable_service { "syslog": }
          }
        }
      }
    }
  }
}
