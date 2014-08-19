# pulsar::service::ntp
#
# Network Time Protocol (NTP) is a networking protocol for clock synchronization
# between computer systems.
# Most security mechanisms require network time to be synchronized.
#
# Refer to Section(s) 3.6 Page(s) 62-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.6 Page(s) 75-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.6 Page(s) 65-6 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 2.4.5.1 Page(s) 35-6 CIS Apple OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 6.5 Page(s) 55-6 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_ntp
# Requires fact: pulsar_hostconfig

class pulsar::service::ntp::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      init_message { "pulsar::service::ntp": }
    }
  }
}

class pulsar::service::ntp::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      if $kernel == "SunOS" and $kernelrelease =~ /10|11/ {
        $service_name = "svc:/network/ntp4:default"
      }
      else {
        if $kernel == "Darwin" {
          $service_name = "org.ntp.ntpd"
        }
        else {
          $service_name = "ntp"
        }
      }
      enable_service { $service_name: }
      if $kernel == "Darwin" {
        add_line_to_file { "TIMESYNC=-YES-": path => "hostconfig" }
      }
      else {
        if $kernel == "Linux" {
          install_package { "ntp": }
          add_line_to_file { "OPTIONS -u ntp:ntp -p /var/run/ntpd.pid": path => "ntp" }
          add_line_to_file { "restrict default kod nomodify nopeer notrap noquery": path => "ntp" }
          add_line_to_file { "restrict -6 default kod nomodify nopeer notrap noquery": path => "ntp" }
        }
      }
    }
  }
}
