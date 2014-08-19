# pulsar::service::vnc
#
# Turn off VNC
#.

# Requires fact: pulsar_systemservices

class pulsar::service::vnc::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::vnc": }
    }
  }
}

class pulsar::service::vnc::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          disable_service { "svc:/application/x11/xvnc-inetd:default": }
        }
      }
      if $kernel == "Linux" {
        disable_service { "vncserver": }
      }
    }
  }
}
