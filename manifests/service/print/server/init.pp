# pulsar::service::print::server
#
# RFC 1179 describes the Berkeley system based line printer protocol.
# The service is used to control local Berkeley system based print spooling.
# It listens on port 515 for incoming print jobs.
# Secure by default limits access to the line printers by only allowing
# print jobs to be initiated from the local system.
# If the machine does not have locally attached printers,
# disable this service.
# Note that this service is not required for printing to a network printer.
#
# Refer to Section(s) 3.14 Page(s) 14-15 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.1-2 Page(s) 34-36 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.1.7 Page(s) 22 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_inittabservices
# Requires fact: pulsar_rc

class pulsar::service::print::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|FreeBSD|AIX/ {
      init_message { "pulsar::service::print::server": }
    }
  }
}

class pulsar::service::print::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|AIX/ {
      if $kernel == "SunOS" {
        if $kernelrelease == "5.10" {
          $service_list = [
            'svc:/application/print/ipp-listener:default',
            'svc:/application/print/rfc1179',
            'svc:/application/print/server:default'
          ]
          disable_service { $service_list: }
        }
      }
      if $kernel == "AIX" {
        $service_list = [ 'qdaemon', 'lpd', 'plobe' ]
        disable_inittab { $service_list: }
      }
      if $kernel == "FreeBSD" {
        add_line_to_file { "lpd_enable = NO": path => "rc" }
      }
    }
    if $kernel == 'SunOS' {
      if $kernelrelease == '5.10' {
        $print_services = [
          'svc:/application/print/ipp-listener:default',
          'svc:/application/print/rfc1179',
          'svc:/application/print/server:default'
        ]
        disable_service { $print_services: }
      }
    }
  }
}
