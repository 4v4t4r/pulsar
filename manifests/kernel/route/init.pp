# pulsar::kernel::route
#
# Network Routing
# Source Packet Forwarding
# Directed Broadcast Packet Forwarding
# Response to ICMP Timestamp Requests
# Response to ICMP Broadcast Timestamp Requests
# Response to ICMP Broadcast Netmask Requests
# Response to Broadcast ICMPv4 Echo Request
# Response to Multicast Echo Request
# Ignore ICMP Redirect Messages
# Strict Multihoming
# ICMP Redirect Messages
# TCP Reverse IP Source Routing
# Maximum Number of Half-open TCP Connections
# Maximum Number of Incoming Connections
#
# The network routing daemon, in.routed, manages network routing tables.
# If enabled, it periodically supplies copies of the system's routing tables
# to any directly connected hosts and networks and picks up routes supplied
# to it from other networks and hosts.
# Routing Internet Protocol (RIP) is a legacy protocol with a number of
# security issues (e.g. no authentication, no zoning, and no pruning).
# Routing (in.routed) is disabled by default in all Solaris 10 systems,
# if there is a default router defined. If no default gateway is defined
# during system installation, network routing is enabled.
#
# Refer to Section(s) 3.4-17 Page(s) 28-39 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 3.5 Page(s) 64-5 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_info_kernel_route
# Requires fact: pulsar_exists_etc_notrouter
# Requires fact: pulsar_routeadm_ipv4-routing
# Requires fact: pulsar_routeadm_ipv6-routing
# Requires fact: pulsar_routeadm_ipv4-forwarding
# Requires fact: pulsar_routeadm_ipv6-forwarding
# Requires fact: pulsar_ipadm_ipv4_forward_src_routed
# Requires fact: pulsar_ipadm_ipv6_forward_src_routed
# Requires fact: pulsar_ipadm_ip_forward_directed_broadcasts
# Requires fact: pulsar_ipadm_ip_respond_to_timestamp
# Requires fact: pulsar_ipadm_ip_respond_to_address_mask_broadcast
# Requires fact: pulsar_ipadm_ip_respond_to_echo_broadcast
# Requires fact: pulsar_ipadm_ipv4_respond_to_echo_multicast
# Requires fact: pulsar_ipadm_ipv6_respond_to_echo_multicast
# Requires fact: pulsar_ipadm_ipv4_ignore_redirect
# Requires fact: pulsar_ipadm_ipv6_ignore_redirect
# Requires fact: pulsar_ipadm_ipv4_send_redirects
# Requires fact: pulsar_ipadm_ipv6_send_redirects
# Requires fact: pulsar_ipadm_ipv4_strict_dst_multihoming
# Requires fact: pulsar_ipadm_ipv6_strict_dst_multihoming
# Requires fact: pulsar_ipadm_tcp_conn_req_max_q0
# Requires fact: pulsar_ipadm_tcp_conn_req_max_q

class pulsar::kernel::route::init {
  if $pulsar_modules =~ /kernel|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::kernel::route": }
    }
  }
}

class pulsar::kernel::route::main {
  if $pulsar_modules =~ /kernel|full/ {
    if $kernel == "SunOS" {
      check_exists { "/etc/notrouter": }
      if $kernelrelease =~ /10|11/ {
        disable_routeadm { "ipv4-routing": }
        disable_routeadm { "ipv6-routing": }
        disable_routeadm { "ipv4-forwarding": }
        disable_routeadm { "ipv6-forwarding": }
      }
      if $kernelrelease == "5.11" {
        check_ipadm_value { "pulsar::kernel::route::_forward_src_routed4":
          driver => "ipv4",
          param  => "_forward_src_routed",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_forward_src_routed6":
          driver => "ipv6",
          param  => "_forward_src_routed",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_forward_directed_broadcasts":
          driver => "ip",
          param  => "_forward_directed_broadcasts",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_respond_to_timestamp":
          driver => "ip",
          param  => "_respond_to_timestamp",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_ip_respond_to_address_mask_broadcast":
          driver => "ip",
          param  => "_ip_respond_to_address_mask_broadcast",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_ip_respond_to_echo_broadcast":
          driver => "ip",
          param  => "_ip_respond_to_echo_broadcast",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_respond_to_echo_multicast4":
          driver => "ipv4",
          param  => "_respond_to_echo_multicast",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_respond_to_echo_multicast6":
          driver => "ipv6",
          param  => "_respond_to_echo_multicast",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_ignore_redirect4":
          driver => "ipv4",
          param  => "_ignore_redirect",
          value  => "1",
        }
        check_ipadm_value { "pulsar::kernel::route::_ignore_redirect6":
          driver => "ipv6",
          param  => "_ignore_redirect",
          value  => "1",
        }
        check_ipadm_value { "pulsar::kernel::route::_send_redirects4":
          driver => "ipv4",
          param  => "_send_redirects",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_send_redirects6":
          driver => "ipv6",
          param  => "_send_redirects",
          value  => "0",
        }
        check_ipadm_value { "pulsar::kernel::route::_strict_dst_multihoming4":
          driver => "ipv4",
          param  => "_strict_dst_multihoming",
          value  => "1",
        }
        check_ipadm_value { "pulsar::kernel::route::_strict_dst_multihoming6":
          driver => "ipv6",
          param  => "_strict_dst_multihoming",
          value  => "1",
        }
        check_ipadm_value { "pulsar::kernel::route::_conn_req_max_q0":
          driver => "tcp",
          param  => "_conn_req_max_q0",
          value  => "4096",
        }
        check_ipadm_value { "pulsar::kernel::route::_conn_req_max_q":
          driver => "tcp",
          param  => "_conn_req_max_q",
          value  => "1024",
        }
      }
    }
  }
}
