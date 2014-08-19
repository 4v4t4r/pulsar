# pulsar::priv::wheel::users
#
# Check users in wheel group have recently logged in, if not lock them
#.

# Requires fact: pulsar_inactivewheelusers

class pulsar::priv::wheel::users::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      init_message { "pulsar::priv::wheel::users": }
    }
  }
}

class pulsar::priv::wheel::users::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      check_wheel_users { "pulsar::priv::wheel::users": }
    }
  }
}
