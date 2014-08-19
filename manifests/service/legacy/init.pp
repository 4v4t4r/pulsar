# pulsar::service::legacy
#
# Turn off inetd and init.d services on Solaris (legacy for Solaris 10+).
# Most of these services have now migrated to the new Service Manifest
# methodology.
#
# Refer to Section(s) 2.1-8 Page(s) 4-8 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.17,24-52 Page(s) 54-5,63-96 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.5 Page(s) 38-9 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.2-11 Page(s) 46-51 CIS Solaris 11.1 v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::legacy::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::legacy": }
    }
  }
}

class pulsar::service::legacy::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernelrelease !~ /11/ {
        $inetd_services = [
          'discard', 'daytime', 'chargen', 'fs', 'dtspc', 'exec', 'comsat',
          'talk', 'finger', 'uucp', 'name', 'xaudio', 'netstat', 'ufsd',
          'rexd', 'systat', 'sun-dr', 'uuidgen', 'krb5_prop', '100068',
          '100146', '100147', '100150', '100221', '100232', '100235', 'kerbd',
          'rstatd', 'rusersd', 'sprayd', 'walld', 'printer', 'shell', 'login',
          'telnet', 'ftp', 'tftp', '100083', '100229', '100230', '100242',
          '100234', '100134', '100155', 'rquotad', '100424', '100422'
        ]
        disable_inet { $inetd_services: }
        $init_services = [
          'llc2', 'pcmcia', 'ppd', 'slpd', 'boot.server', 'autoinstall', 'power',
          'bdconfig', 'cachefs.daemon', 'cacheos.finish', 'asppp', 'uucp',
          'flashprom', 'PRESERVE', 'ncalogd','ncad', 'ab2mgr', 'dmi', 'mipagent',
          'nfs.client', 'autofs', 'rpc', 'directory', 'ldap.client', 'lp', 'spc',
          'volmgt', 'dtlogin', 'ncakmod', 'samba', 'dhcp', 'nfs.server',
          'kdc.master', 'kdc', 'apache', 'snmpdx'
        ]
        disable_init { $init_services: }
      }
    }
  }
}
