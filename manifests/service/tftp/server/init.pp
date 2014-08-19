# pulsar::service::tftp::server
#
# Turn off tftp
#
# Trivial File Transfer Protocol (TFTP) is a simple file transfer protocol,
# typically used to automatically transfer configuration or boot machines
# from a boot server. The package tftp-server is the server package used to
# define and support a TFTP server.
# TFTP does not support authentication nor does it ensure the confidentiality
# of integrity of data. It is recommended that TFTP be removed, unless there
# is a specific need for TFTP. In that case, extreme caution must be used when
# configuring the services.
#
# Refer to Section(s) 2.1.8 Page(s) 52 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.8 Page(s) 60 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 5.1.8 Page(s) 45 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.9 Page(s) 58-9 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_installedpackages

class pulsar::service::tftp::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::tftp::server": }
    }
  }
}

class pulsar::service::tftp::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          $service_list = [ "svc:/network/tftp/udp6:default",
                            "svc:/network/tftp/udp4:default" ]
        }
        else {
          $service_list = "tftp"
        }
      }
      if $kernel == "Linux" {
        $service_list = "tftp"
      }
      disable_service { $service_list: }
    }
    if $kernel == "Linux" {
      if $lsbdistid =~ /CentOS|Red/ {
        uninstall_package { "tftp-server": }
      }
    }
  }
}
