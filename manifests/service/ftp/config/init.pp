# pulsar::service::ftp::config
#
# Audit FTP Configuration
#.

# Requires fact: pulsar_ftpdaccess

class pulsar::service::ftp::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::ftp::config": }
    }
  }
}

class pulsar::service::ftp::config::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease == "5.10" {
          add_line_to_file { "banner /etc/ftpd/banner.msg": path => "ftpdaccess" }
        }
      }
    }
  }
}
