# pulsar::service::vopied
#
# Veritas Online Passwords In Everything
#
# Turn off vopied if not required. It is associated with Symantec products.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::vopied::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::vopied": }
    }
  }
}

class pulsar::service::vopied::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        disable_service { "svc:/network/vopied/tcp:default": }
      }
    }
  }
}
