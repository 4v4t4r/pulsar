# pulsar::service::cde::print
#
# CDE Printing services. Not required unless running CDE applications.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::cde::print::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        init_message { "pulsar::service::cde::print": }
      }
    }
  }
}

class pulsar::service::cde::print::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        disable_service { 'svc:/application/cde-printinfo:default': }
      }
    }
  }
}
