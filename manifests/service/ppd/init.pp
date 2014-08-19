# pulsar::service::ppd
#
# Cache for Printer Descriptions. Not required unless using print services.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::ppd::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        init_message { "pulsar::service::ppd": }
      }
    }
  }
}

class pulsar::service::ppd::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        disable_service { "svc:/application/print/ppd-cache-update:default": }
      }
    }
  }
}
