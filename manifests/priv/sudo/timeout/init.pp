# pulsar::priv::sudo::timeout
#
# The sudo command stays logged in as the root user for five minutes before
# timing out and re-requesting a password. This five minute window should be
# eliminated since it leaves the system extremely vulnerable.
# This is especially true if an exploit were to gain access to the system,
# since they would be able to make changes as a root user.
#
# Refer to Section 5.1 Page(s) 48-49 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_sudoers

class pulsar::priv::sudo::timeout::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      init_message { "pulsar::priv::sudo::timeout": }
    }
  }
}

class pulsar::priv::sudo::timeout::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      add_line_to_file { "Defaults timestamp_timeout=0": path => "sudoers" }
    }
  }
}
