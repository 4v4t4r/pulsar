# pulsar::service::bonjour
#
# OSX writes information pertaining to system-related events to the
# file /var/log/system.log and has a configurable retention policy for
# this file.
#
# Archiving and retaining system.log for 30 or more days is beneficial in
# the event of an incident as it will allow the user to view the various
# changes to the system along with the date and time they occurred.
#
# Refer to Section 3.4-7 Page(s) 39-40 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 2.4.14.14 Page(s) 62-3 CIS Apple OS X 10.5 Benchmark v1.1.0
#.

# Requires fact: pulsar_launchctl_com.apple.mDNSResponder.plist_ProgramArguments

class pulsar::service::bonjour::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::bonjour": }
    }
  }
}

class pulsar::service::bonjour::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'Darwin' {
      check_bonjour { "pulsar::service::bonjour::NoMulticastAdvertisements": }
    }
  }
}
