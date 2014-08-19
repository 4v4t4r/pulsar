# pulsar::service::ssh::keys
#
# Make sure there are no ssh keys for root
#.

# Requires fact: pulsar_info_service_ssh_keys

class pulsar::service::ssh::keys::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      init_message { "pulsar::service::ssh::keys": }
    }
  }
}

class pulsar::service::ssh::keys::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      disable_ssh_keys { "root": }
    }
  }
}
