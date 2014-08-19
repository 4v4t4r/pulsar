# pulsar::service::labeld
#
# Turn off labeld
#.

# Requires fact: pulsar_systemservices

class pulsar::service::labeld::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::labeld": }
    }
  }
}

class pulsar::service::labeld::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/system/labeld:default': }
      }
    }
  }
}
