# pulsar::os::update
#
# Ensure OS X is set to autoupdate
#
# Refer to Page(s) 8 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_softwareupdateschedule

class pulsar::os::update::init {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::os::update": }
    }
  }
}

class pulsar::os::update::main {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel == "Darwin" {
      check_software_update { "pulsar::os::update": }
    }
  }
}
