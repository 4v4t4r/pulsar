# pulsar::service::font
#
# Turn off font server
#.

# Requires fact: pulsar_systemservices

class pulsar::service::font::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::font": }
    }
  }
}

class pulsar::service::font::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease =~ /10|11/ {
          $font_service_list = [
            'svc:/application/x11/xfs:default',
            'svc:/application/font/stfsloader:default',
            'svc:/application/font/fc-cache:default'
          ]
        }
      }
      else {
        $font_service_list = "xfs"
      }
      disable_service { $font_service_list: }
    }
  }
}
