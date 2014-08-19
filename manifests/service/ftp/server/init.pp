# pulsar::service::ftp::server
#
# Turn off ftp server
#.

# Require fact: pulsar_systemservices

class pulsar::service::ftp::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::ftp::server": }
    }
  }
}

class pulsar::service::ftp::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/network/ftp:default': }
      }
    }
  }
}
