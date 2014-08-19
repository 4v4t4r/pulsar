# pulsar::security::tcp::strength
#
# Strong TCP Sequence Number Generation
#
# Checks for the following values in /etc/default/inetinit:
#
# TCP_STRONG_ISS=2
#
# The variable TCP_STRONG_ISS sets the mechanism for generating the order of
# TCP packets. If an attacker can predict the next sequence number, it is
# possible to inject fraudulent packets into the data stream to hijack the
# session. Solaris supports three sequence number methods:
#
# 0 = Old-fashioned sequential initial sequence number generation.
# 1 = Improved sequential generation, with random variance in increment.
# 2 = RFC 1948 sequence number generation, unique-per-connection-ID.
#
# The RFC 1948 method is widely accepted as the strongest mechanism for TCP
# packet generation. This makes remote session hijacking attacks more difficult,
# as well as any other network-based attack that relies on predicting TCP
# sequence number information. It is theoretically possible that there may be a
# small performance hit in connection setup time when this setting is used, but
# there are no benchmarks that establish this.
#
# Refer to Section(s) 3.3 Page(s) 27-8 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 3.4 Page(s) 63-4 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_inetinit
# Requires fact: pulsar_ndd_tcp_tcp_strong_iss
# Requires fact: pulsar_ipadm_tcp_strong_iss

class pulsar::security::tcp::strength::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::security::tcp::strength": }
    }
  }
}

class pulsar::security::tcp::strength::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /11/ {
        check_ipadm_value { "pulsar::security::tcp::strength::_strong_iss":
          driver => "tcp",
          param  => "_strong_iss",
          value  => "2",
        }
      }
      else {
        check_ndd_value { "pulsar::security::tcp::strength::tcp_strong_iss":
          driver => "/dev/tcp",
          param  => "tcp_strong_iss",
          value  => "2",
        }
      }
      add_line_to_file { "TCP_STRONG_ISS=2": path => "inetinit" }
    }
  }
}
