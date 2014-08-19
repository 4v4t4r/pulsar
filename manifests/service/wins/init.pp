# pulsar::service::wins
#
# Turn off wins if not required
#.

# Requires fact: pulsar_systemservices

class pulsar::service::wins::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::wins": }
    }
  }
}

class pulsar::service::wins::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease =~ /10|11/ {
          disable_service { 'svc:/network/wins:default': }
        }
      }
      if $kernel == 'Linux' {
        disable_service { 'winbindd': }
      }
    }
  }
}
