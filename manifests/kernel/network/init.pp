# pulsar::kernel::network
#
# Network device drivers have parameters that can be set to provide stronger
# security settings, depending on environmental needs. This section describes
# modifications to network parameters for IP, ARP and TCP.
# The settings described in this section meet most functional needs while
# providing additional security against common network attacks. However,
# it is important to understand the needs of your particular environment
# to determine if these settings are appropriate for you.
#
# The ip_forward_src_routed and ip6_forward_src_routed parameters control
# whether IPv4/IPv6 forwards packets with source IPv4/IPv6 routing options
# Keep this parameter disabled to prevent denial of service attacks through
# spoofed packets.
#
# The ip_forward_directed_broadcasts parameter controls whether or not Solaris
# forwards broadcast packets for a specific network if it is directly connected
# to the machine.
# The default value of 1 causes Solaris to forward broadcast packets.
# An attacker could send forged packets to the broadcast address of a remote
# network, resulting in a broadcast flood. Setting this value to 0 prevents
# Solaris from forwarding these packets. Note that disabling this parameter
# also disables broadcast pings.
#
# The ip_respond_to_timestamp parameter controls whether or not to respond to
# ICMP timestamp requests.
# Reduce attack surface by restricting a vector for host discovery.
#
# The ip_respond_to_timestamp_broadcast parameter controls whether or not to
# respond to ICMP broadcast timestamp requests.
# Reduce attack surface by restricting a vector for bulk host discovery.
#
# The ip_respond_to_address_mask_broadcast parameter controls whether or not
# to respond to ICMP netmask requests, typically sent by diskless clients when
# booting.
# An attacker could use the netmask information to determine network topology.
# The default value is 0.
#
# The ip6_send_redirects parameter controls whether or not IPv6 sends out
# ICMPv6 redirect messages.
# A malicious user can exploit the ability of the system to send ICMP redirects
# by continually sending packets to the system, forcing the system to respond
# with ICMP redirect messages, resulting in an adverse impact on the CPU and
# performance of the system.
#
# The ip_respond_to_echo_broadcast parameter controls whether or not IPv4
# responds to a broadcast ICMPv4 echo request.
# Responding to echo requests verifies that an address is valid, which can aid
# attackers in mapping out targets. ICMP echo requests are often used by
# network monitoring applications.
#
# The ip6_respond_to_echo_multicast and ip_respond_to_echo_multicast parameters
# control whether or not IPv6 or IPv4 responds to a multicast IPv6 or IPv4 echo
# request.
# Responding to multicast echo requests verifies that an address is valid,
# which can aid attackers in mapping out targets.
#
# The ip_ire_arp_interval parameter determines the intervals in which Solaris
# scans the IRE_CACHE (IP Resolved Entries) and deletes entries that are more
# than one scan old. This interval is used for solicited arp entries, not
# un-solicited which are handled by arp_cleanup_interval.
# This helps mitigate ARP attacks (ARP poisoning). Consult with your local
# network team for additional security measures in this area, such as using
# static ARP, or fixing MAC addresses to switch ports.
#
# The ip_ignore_redirect and ip6_ignore_redirect parameters determine if
# redirect messages will be ignored. ICMP redirect messages cause a host to
# re-route packets and could be used in a DoS attack. The default value for
# this is 0. Setting this parameter to 1 causes redirect messages to be
# ignored.
# IP redirects should not be necessary in a well-designed, well maintained
# network. Set to a value of 1 if there is a high risk for a DoS attack.
# Otherwise, the default value of 0 is sufficient.
#
# The ip_strict_dst_multihoming and ip6_strict_dst_multihoming parameters
# determines whether a packet arriving on a non -forwarding interface can be
# accepted for an IP address that is not explicitly configured on that
# interface. If ip_forwarding is enabled, or xxx:ip_forwarding (where xxx is
# the interface name) for the appropriate interfaces is enabled, then this
# parameter is ignored because the packet is actually forwarded.
# Set this parameter to 1 for systems that have interfaces that cross strict
# networking domains (for example, a firewall or a VPN node).
#
# The ip_send_redirects parameter controls whether or not IPv4 sends out
# ICMPv4 redirect messages.
# A malicious user can exploit the ability of the system to send ICMP
# redirects by continually sending packets to the system, forcing the system
# to respond with ICMP redirect messages, resulting in an adverse impact on
# the CPU performance of the system.
#
# The arp_cleanup_interval parameter controls the length of time, in
# milliseconds, that an unsolicited Address Resolution Protocal (ARP)
# request remains in the ARP cache.
# If unsolicited ARP requests are allowed to remain in the ARP cache for long
# periods an attacker could fill up the ARP cache with bogus entries.
# Set this parameter to 60000 ms (1 minute) to reduce the effectiveness of ARP
# attacks. The default value is 300000.
#
# The tcp_rev_src_routes parameter determines if TCP reverses the IP source
# routing option for incoming connections. If set to 0, TCP does not reverse
# IP source. If set to 1, TCP does the normal reverse source routing.
# The default setting is 0.
# If IP source routing is needed for diagnostic purposes, enable it.
# Otherwise leave it disabled.
#
# The tcp_conn_req_max_q0 parameter determines how many half-open TCP
# connections can exist for a port. This setting is closely related with
# tcp_conn_req_max_q.
# It is necessary to control the number of completed connections to the system
# to provide some protection against Denial of Service attacks. Note that the
# value of 4096 is a minimum to establish a good security posture for this
# setting. In environments where connections numbers are high, such as a busy
# webserver, this value may need to be increased.
#
# The tcp_conn_req_max_q parameter determines the maximum number of incoming
# connections that can be accepted on a port. This setting is closely related
# with tcp_conn_req_max_q0.
# Restricting the number of "half open" connections limits the damage of DOS
# attacks where the attacker floods the network with "SYNs". Having this split
# from the tcp_conn_req_max_q parameter allows the administrator some discretion
# in this area.
# Note that the value of 1024 is a minimum to establish a good security posture
# for this setting. In environments where connections numbers are high, such as
# a busy webserver, this value may need to be increased.
#.

# Requires fact: pulsar_nddnetwork
# Requires fact: pulsar_perms_etc_init.d_nddnetwork
# Requires fact: pulsar_symlink_etc_rc3.d_S99nddnetwork
# Requires fact: pulsar_symlink_etc_rc0.d_K99nddnetwork

class pulsar::kernel::network::init {
  if $pulsar_modules =~ /kernel|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::kernel::network": }
    }
  }
}

class pulsar::kernel::network::main {
  if $pulsar_modules =~ /kernel|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease !~ /11/ {
        check_ndd_init { "pulsar::kernel::network": }
        check_file_perms { "/etc/init.d/nddnetwork":
          owner => "root",
          group => "root",
          mode  => "750",
        }
        check_symlink { "/etc/rc3.d/S99nddnetwork": target => "/etc/init.d/nddnetwork" }
        check_symlink { "/etc/rc0.d/K99nddnetwork": target => "/etc/init.d/nddnetwork" }
      }
    }
  }
}
