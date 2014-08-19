# pulsar::service::ftp::umask
#
# If FTP is permitted, set the umask value to apply to files created by the
# FTP server.
# Many users assume that files transmitted over FTP inherit their system umask
# value when they do not. This setting ensures that files transmitted over FTP
# are protected.o#.

# Requires fact: pulsar_ftpaccess
# Requires fact: pulsar_ftpd

class pulsar::service::ftp::umask::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::ftp::umask": }
    }
  }
}

class pulsar::service::ftp::umask::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease == "5.10" {
          add_line_to_file { "defumask 077": path => "ftpaccess" }
        }
        if $kernelrelease == "5.11" {
          add_line_to_file { "Umask 077": path => "ftpaccess" }
        }
      }
      if $kernel == "Linux" {
        add_line_to_file { "Umask 077": path => "ftpaccess" }
      }
    }
  }
}
