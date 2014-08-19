# pulsar::service::bpjava
#
# BPJava Service
#
# Turn off bpjava-msvc if not required. It is associated with NetBackup.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::bpjava::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        init_message { "pulsar::service::bpjava": }
      }
    }
  }
}

class pulsar::service::bpjava::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/network/bpjava-msvc/tcp:default': }
      }
    }
  }
}
