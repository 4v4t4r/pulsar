# pulsar::firewall::osx
#
# Apple's firewall will protect your computer from certain incoming attacks.
# Apple offers three firewall options: Allow all, Allow only essential, and
# Allow access for specific incoming connections. Unless you have a specific
# need to allow incoming connection (for services such as SSH, file sharing,
# or web services), set the firewall to "Allow only essential services,"
# otherwise use the "allow access for specific incoming connections" option.
#
# 0 = off
# 1 = on for specific services
# 2 = on for essential services
#
# Refer to Section(s) 2.6.4 Page(s) 30-31 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.alf_globalstate

class pulsar::firewall::osx::init {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::firewall::osx": }
    }
  }
}

class pulsar::firewall::osx::main {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::firewall::osx::alf":
        pfile => "com.apple.alf",
        param => "globalstate",
        value => "1",
      }
    }
  }
}
