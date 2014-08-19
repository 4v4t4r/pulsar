# pulsar::firewall::tcpwrappers
#
# TCP Wrappers is a host-based access control system that allows administrators
# to control who has access to various network services based on the IP address
# of the remote end of the connection. TCP Wrappers also provide logging
# information via syslog about both successful and unsuccessful connections.
# Rather than enabling TCP Wrappers for all services with "inetadm -M ...",
# the administrator has the option of enabling TCP Wrappers for individual
# services with "inetadm -m <svcname> tcp_wrappers=TRUE", where <svcname> is
# the name of the specific service that uses TCP Wrappers.
#
# TCP Wrappers provides more granular control over which systems can access
# services which limits the attack vector. The logs show attempted access to
# services from non-authorized systems, which can help identify unauthorized
# access attempts.
#
# The /etc/hosts.allow file specifies which IP addresses are permitted to
# connect to the host. It is intended to be used in conjunction with the
# /etc/hosts.deny file.
# The /etc/hosts.allow file supports access control by IP and helps ensure
# that only authorized systems can connect to the server.
# The /etc/hosts.allow file contains networking information that is used by
# many applications and therefore must be readable for these applications to
# operate.
# It is critical to ensure that the /etc/hosts.allow file is protected from
# unauthorized write access. Although it is protected by default, the file
# permissions could be changed either inadvertently or through malicious actions.
#
# The /etc/hosts.deny file specifies which IP addresses are not permitted to
# connect to the host. It is intended to be used in conjunction with the
# /etc/hosts.allow file.
# The /etc/hosts.deny file serves as a failsafe so that any host not specified
# in /etc/hosts.allow is denied access to the server.
# The /etc/hosts.deny file contains network information that is used by many
# system applications and therefore must be readable for these applications to
# operate.
# It is critical to ensure that the /etc/hosts.deny file is protected from
# unauthorized write access. Although it is protected by default, the file
# permissions could be changed either inadvertently or through malicious actions.
#
# Refer to Section(s) 5.5.1-5 Page(s) 110-114 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.5.1-5 Page(s) 95-8 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 4.5.1-5 Page(s) 86-9 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 7.4.1-5 Page(s) 77-80 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3 Page(s) 3-4 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.10.1-4 Page(s) 188-192 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.11 Page(s) 22-3 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.4 Page(s) 36-7 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_rc
# Requires fact: pulsar_hostsdeny
# Requires fact: pulsar_hostsallow

class pulsar::firewall::tcpwrappers::init {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|Darwin|AIX/ {
      init_message { "pulsar::firewall::tcpwrappers": }
      if $kernel == "Linux" {
        if $lsbdistid =~ /CentOS|SuSE|Red/ {
          install_package { "tcp_wrappers": }
        }
      }
      if $kernel == "AIX" {
        install_package { "netsec.options.tcpwrapper.base": }
      }
    }
  }
}

class pulsar::firewall::tcpwrappers::main {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|Darwin|AIX/ {
      if $kernel == "AIX" {
        $group = "system"
      }
      if $kernel == "FreeBSD" {
        add_line_to_file { "inetd_enable = YES": path => "rc" }
        add_line_to_file { "inetd_flags = -Wwl -C60": path => "rc" }
        $group = "root"
      }
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          $service_list = [
            "svc:/application/cups/in-lpd:default",
            "svc:/network/security/ktkt_warn:default",
            "svc:/network/telnet:default",
            "svc:/network/echo:dgram",
            "svc:/network/echo:stream",
            "svc:/network/tftp/udp6:default",
            "svc:/network/login:eklogin",
            "svc:/network/login:klogin",
            "svc:/network/login:rlogin",
            "svc:/network/nfs/rquota:default",
            "svc:/network/time:dgram",
            "svc:/network/time:stream",
            "svc:/network/daytime:dgram",
            "svc:/network/daytime:stream",
            "svc:/network/finger:default",
            "svc:/network/rpc/smserver:default",
            "svc:/network/rpc/rstat:default",
            "svc:/network/rpc/rusers:default",
            "svc:/network/rpc/gss:default",
            "svc:/network/rpc/rex:default",
            "svc:/network/rpc/spray:default",
            "svc:/network/rpc/wall:default",
            "svc:/network/stdiscover:default",
            "svc:/network/rexec:default",
            "svc:/network/shell:default",
            "svc:/network/shell:kshell",
            "svc:/network/chargen:dgram",
            "svc:/network/chargen:stream",
            "svc:/network/discard:dgram",
            "svc:/network/discard:stream",
            "svc:/network/stlisten:default",
            "svc:/network/talk:default",
            "svc:/network/comsat:default"
          ]
          enable_tcpwrappers { $service_list: }
          $group = "root"
        }
      }
      check_file_perms { "/etc/hosts.allow":
        mode  => "0644",
        owner => "root",
        group => $group,
      }
      check_file_perms { "/etc/hosts.deny":
        mode  => "0644",
        owner => "root",
        group => $group,
      }
      add_line_to_file { "ALL: ALL": path => "hostsdeny" }
      add_line_to_file { "ALL: localhost": path => "hostsallow" }
      add_line_to_file { "ALL: 127.0.0.1": path => "hostsallow" }
    }
  }
}
