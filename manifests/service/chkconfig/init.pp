# pulsar::service::chkconfig
#
# Check services are turned off via chkconfig in Linux that do not need to be
# enabled.
# Running services that are not required can leave potential vectors of attack
# open.
#
# Refer to Section(s) 1.2.4-5 Page(s) 36-7 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.2.4-5 Page(s) 34-5 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.16 Page(s) 63-4 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::chkconfig::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::chkconfig": }
    }
  }
}

class pulsar::service::chkconfig::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      $service_list = [ 'wu-ftpd', 'ftp', 'vsftpd', 'aaeventd', 'acpid',
        'amd', 'arptables_jg', 'arpwatch', 'atd', 'netfs', 'irda', 'isdn',
        'bluetooth', 'capi', 'conman', 'cpuspeed', 'cryrus-imapd', 'dc_client',
        'dc_server', 'dhcdbd', 'dhcp6s', 'dhcrelay', 'chargen', 'chargen-udp',
        'dund', 'gpm', 'hidd', 'hplip', 'ibmasm', 'innd', 'ip6tables',
        'lisa', 'lm_sensors', 'mailman', 'mctrans', 'mdmonitor', 'mdmpd',
        'microcode_ctl', 'mysqld', 'netplugd', 'network', 'NetworkManager',
        'openibd', 'pand', 'postfix', 'psacct', 'mutipathd', 'daytime',
        'daytime-udp', 'radiusd', 'radvd', 'rdisc', 'readahead_early',
        'readahead_later', 'rhnsd', 'rpcgssd', 'rpcimapd', 'rpcsvcgssd',
        'rstatd', 'rusersd', 'rwhod', 'saslauthd', 'settroubleshoot', 'smartd',
        'spamassasin', 'echo', 'echo-udp', 'time', 'time-udp', 'vnc', 'svcgssd',
        'rpmconfigcheck', 'rsh', 'rsync', 'rsyncd', 'powerd', 'raw', 'rexec',
        'rlogin', 'rpasswdd', 'openct', 'ipxmount', 'joystick', 'esound',
        'evms', 'fam', 'gssd', 'tog-pegasus', 'tux', 'wpa_supplicant',
        'zebra', 'ncpf'
      ]
      disable_service { $service_list: }
    }
  }
}
