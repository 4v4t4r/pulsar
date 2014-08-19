# pulsar::service::keyserv::config
#
# The keyserv process, if enabled, stores user keys that are utilized with
# Sun's Secure RPC mechanism.
# The action listed prevents keyserv from using default keys for the nobody
# user, effectively stopping this user from accessing information via Secure
# RPC.
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_keyserver

class pulsar::service::keyserv::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        init_message { "pulsar::service::keyserv::config": }
      }
    }
  }
}

class pulsar::service::keyserv::config::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease == '5.10' {
        add_line_to_file { "ENABLE_NOBODY_KEYS=NO": path => "keyserv" }
      }
    }
  }
}
