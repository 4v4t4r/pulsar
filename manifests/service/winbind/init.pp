# pulsar::service::winbind
#
# Turn off winbind if not required
#.

# Requires fact: pulsar_systemservices

class pulsar::service::winbind::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::winbind": }
    }
  }
}

class pulsar::service::winbind::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease =~ /10|11/ {
          disable_service { 'svc:/network/winbind:default': }
        }
      }
      if $kernel == 'Linux' {
        disable_service { 'winbind': }
      }
    }
  }
}
