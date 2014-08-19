# pulsar::security::tcp::cookies
#
# TCP SYN Cookies Protection
#
# Refer to Section(s) 4.2.8 Page(s) 90-1 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 4.2.8 Page(s) 82-3 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_rclocal
# Requires fact: pulsar_perms_etc_rc.d_local

class pulsar::security::tcp::cookies::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::security::tcp::cookies": }
    }
  }
}

class pulsar::security::tcp::cookies::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      add_line_to_file { "echo 1 > /proc/sys/net/ipv4/tcp_syncookies": path => "rclocal" }
      check_perms { "/etc/rc.d/local":
        mode  => "0600",
        owner => "root",
        group => "root",
      }
    }
  }
}
