# pulsar::service::nis::server
#
# These daemons are only required on systems that are acting as an
# NIS server for the local site. Typically there are only a small
# number of NIS servers on any given network.
# These services are disabled by default unless the system has been
# previously configured to act as a NIS server.
#
# Refer to Section(s) 2.1.7 Page(s) 51-52 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.6 Page(s) 58-9 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.6 Page(s) 53-4 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.1.1 Page(s) 40 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 3.12-3 Page(s) 13-14 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.4 Page(s) 17-8 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.2.2 Page(s) 23-4 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::nis::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::nis::server": }
    }
  }
}

class pulsar::service::nis::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease =~ /10|11/ {
          if $kernelrelease == '5.10' {
            $nis_services = [
              'svc:/network/nis/server', 'svc:/network/nis/passwd',
              'svc:/network/nis/update', 'svc:/network/nis/xfr"'
            ]
          }
          if $kernelrelease == '5.11' {
            $nis_services = [
              'svc:/network/nis/server', '"svc:/network/nis/domain'
            ]
          }
          disable_service { $nis_services: }
        }
      }
    }
   if $kernel == 'Linux' {
      $nis_services = [ 'yppasswdd', 'ypserv', 'ypxfrd' ]
      disable_service { $nis_services: }
    }
  }
}
