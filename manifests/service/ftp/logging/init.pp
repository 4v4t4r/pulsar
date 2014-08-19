# pulsar::service::ftp::logging
#
# Information about FTP sessions will be logged via syslogd (1M),
# but the system must be configured to capture these messages.
# If the FTP daemon is installed and enabled, it is recommended that the
# "debugging" (-d) and connection logging (-l) flags also be enabled to
# track FTP activity on the system. Note that enabling debugging on the FTP
# daemon can cause user passwords to appear in clear-text form in the system
# logs, if users accidentally type their passwords at the username prompt.
# All of this information is logged by syslogd (1M), but syslogd (1M) must be
# configured to capture this information to a separate file so it may be more
# easily reviewed.
#.

# Requires fact: pulsar_installedpackages
# Requires fact: pulsar_vsftpd
# Requires fact: pulsar_perms_configfile_vsftpd

# Need to add ftp logging to Solaris versions 9 and below

class pulsar::service::ftp::logging::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::ftp::logging": }
    }
  }
}

class pulsar::service::ftp::logging::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease =~ /10|11/ {
          check_exec { 'ftpd_logging':
            exec  => 'inetadm -m svc:/network/ftp exec="/usr/sbin/in.ftpd -a -l -d"',
            check => 'svcprop -p inetd_start/exec svc:/network/ftp:default |grep "-d"',
            value => "-d",
          }
        }
      }
      if $kernel == 'Linux' {
        if $pulsar_linux_installedpackages =~ /vsftpd/ {
          add_line_to_file { "log_ftp_protocol=YES": path => "vsftpd" }
          add_line_to_file { "ftpd_banner=\"Authorized users only. All activity may be monitored and reported.\"": path => "vsftpd" }
        }
        check_perms { "vsftpd":
          owner => 'root',
          group => 'root',
          mode  => '600',
        }
      }
    }
  }
}
