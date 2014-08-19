# pulsar::service::xen
#
# Xen is a hypervisor providing services that allow multiple computer
# operating systems to execute on the same computer hardware concurrently.
#
# Turn off Xen services if they are not being used.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::xen::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::xen": }
    }
  }
}

class pulsar::service::xen::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'Linux' {
      $service_list = [ 'xend', 'xendomains' ]
      disable_service { $service_list: }
    }
  }
}
