# pulsar::service::snmp
#
# Simple Network Management Protocol (SNMP) is an "Internet-standard protocol
# for managing devices on IP networks". Devices that typically support SNMP
# include routers, switches, servers, workstations, printers, modem racks, and
# more. It is used mostly in network management systems to monitor network-
# attached devices for conditions that warrant administrative attention.
# Turn off SNMP if not used. If SNMP is used lock it down. SNMP can reveal
# configuration information about systems leading to vectors of attack.
#
# Refer to Section(s) 3.15 Page(s) 69 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.15 Page(s) 81-2 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.15 Page(s) 71-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.14 Page(s) 61-2 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3.7,18-21 Page(s) 41-2,55-60 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_snmp
# Requires fact: pulsar_installedpackages
# Requires fact: pulsar_perms_var_tmp_snmpd.log
# Requires fact: pulsar_perms_var_tmp_hostmibd.log
# Requires fact: pulsar_perms_var_tmp_dpid2.log
# Requires fact: pulsar_perms_var_ct_RMstart.log
# Requires fact: pulsar_perms_smit.log
# Requires fact: pulsar_perms_var_adm_ras
# Requires fact: pulsar_rctcpservices

class pulsar::service::snmp::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|AIX/ {
      init_message { "pulsar::service::snmp": }
    }
  }
}

class pulsar::service::snmp::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|AIX/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          $service_list = [
            'svc:/application/management/seaport:default',
            'svc:/application/management/snmpdx:default',
            'svc:/application/management/dmi:default',
            'svc:/application/management/sma:default'
          ]
        }
        else {
          $service_list = [ 'init.dmi', 'init.sma', 'init.snmpdx' ]
        }
        disable_service { $service_list: }
      }
      if $kernel == "Linux" {
        $service_list = [ 'snmpd', 'snmptrapd' ]
        disable_service { $service_list: }
        if $lsbdistid =~ /CentOS|Red|Scientific/ {
          uninstall_package { "net-snmp": }
        }
        add_line_to_file { "com2sec notConfigUser default public": path => "snmpd" }
      }
      if $kernel == "AIX" {
        $service_list = [ 'snmpd', 'dpid2', 'hostmibd', 'snmpmibd', 'aixmibd' ]
        disable_aix_rctcp { $service_list: }
        $file_list = [ '/var/tmp/snmpd.log', '/var/tmp/hostmibd.log',
                       '/var/tmp/dpid2.log', '/var/ct/RMstart.log', '/smit.log' ]
        check_file_perms { $file_list:
          mode  => "0640",
          owner => "root",
          group => "system",
        }
        check_file_perms { "/var/adm/ras":
          mode  => "0040",
          owner => "root",
          group => "system",
        }
      }
    }
  }
}
