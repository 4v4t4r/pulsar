# pulsar::priv::wheel::group
#
# Make sure there is a wheel group so privileged account access is limited.
#.

# Requires fact: pulsar_groupexists_wheel

class pulsar::priv::wheel::group::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::priv::wheel::group": }
    }
  }
}

class pulsar::priv::wheel::group::main {
  if $pulsar_modules =~ /priv|full/ {
    $group = "wheel"
    if $kernel =~ /SunOS|Linux/ {
      $fact = $pulsar_groupexists_wheel
      check_group_exists { $group: fact => $fact }
    }
  }
}
