# pulsar::service::iscsi::client
#
# Turn off iscsi target
#.

# Requires fact: pulsar_systemservices

class pulsar::service::iscsi::client::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::iscsi::client": }
    }
  }
}

class pulsar::service::iscsi::client::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          disable_service { "svc:/system/iscsitgt:default": }
        }
      }
      if $kernel == "Linux" {
        disable_service { "iscsi": }
      }
    }
  }
}
