# pulsar::os::shells
#
# Check that shells in /etc/shells exist
#.

# Requires fact: pulsar_invalidshells

class pulsar::os::shells::init {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::os::shells": }
    }
  }
}

class pulsar::os::shells::main {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel =~ /SunOS|Linux/ {
      handle_invalid_shells{ "pulsar::os::shells": }
    }
  }
}
