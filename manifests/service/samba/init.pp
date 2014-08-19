# pulsar::service::samba
#
# Solaris includes the popular open source Samba server for providing file
# and print services to Windows-based systems. This allows a Solaris system
# to act as a file or print server on a Windows network, and even act as a
# Domain Controller (authentication server) to older Windows operating
# systems. Note that on Solaris releases prior to 11/06 the file
# /etc/sfw/smb.conf does not exist and the service will not be started by
# default even on newer releases.
#
# Refer to Section(s) 3.13 Page(s) 68 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.13 Page(s) 80 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.12 Page(s) 60-1 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.4 Page(s) 55 CIS OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 2.2.9 Page(s) 29-30 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_samba
# Requires fact: pulsar_systemservices
# Requires fact: pulsar_installedpackages

# Needs edit module TBD

class pulsar::service::samba::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      init_message { "pulsar::service::samba": }
    }
  }
}

class pulsar::service::samba::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      $path = "samba"
      check_value { "pulsar::service::samba::restrict":
        path  => $path,
        line  => "restrict anonymous",
        after => "[Global]",
      }
      check_value { "pulsar::service::samba::guest":
        path  => $path,
        line  => "guest OK",
        after => "[Global]",
      }
      check_value { "pulsar::service::samba::client":
        path  => $path,
        line  => "client ntlmv2 auth",
        after => "[Global]",
      }
    }
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "Linux" {
        $service_name = "smb"
      }
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          if $kernelrelease == "5.11" {
            $service_name = "svc:/network/samba"
          }
          else {
            if $kernelrelease == "5.10" {
              if $operatingsystemupdate > 4 {
                $service_name = "svc:/network/samba"
              }
              else {
                $service_name = "samba"
              }
            }
          }
        }
        else {
          $service_name = "samba"
        }
      }
      disable_service { $service_name: }
    }
  }
}

class pulsar::service::samba::post {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      uninstall_package { "samba": }
    }
  }
}
