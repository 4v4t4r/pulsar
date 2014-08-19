# pulsar::service::iscsi::server
#
# Turn off iscsi initiator
#.

# Requires fact: pulsar_systemservices

class pulsar::service::iscsi::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::iscsi::server": }
    }
  }
}

class pulsar::service::iscsi::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          disable_service { "svc:/network/iscsi/initiator:default": }
        }
      }
      if $kernel == "Linux" {
        disable_service { "iscsid": }
      }
    }
  }
}
