# pulsar::service::nat
#
# Internet Sharing uses the open source natd process to share an internet
# connection with other computers and devices on a local network.
#
# Refer to Section 2.4.2 Page(s) 17-18 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.nat_com.apple.InternetSharing

# Needs fixing

class pulsar::service::nat::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::nat": }
    }
  }
}

class pulsar::service::nat::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::service::nat::InternetSharing":
        pfile => "com.apple.nat",
        param => "com.apple.InternetSharing",
        value => "off",
      }
    }
  }
}
