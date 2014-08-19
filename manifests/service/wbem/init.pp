# pulsar::service::wbem
#
# Web-Based Enterprise Management (WBEM) is a set of management and Internet
# technologies. Solaris WBEM Services software provides WBEM services in the
# Solaris OS, including secure access and manipulation of management data.
# The software includes a Solaris platform provider that enables management
# applications to access information about managed resources such as devices
# and software in the Solaris OS. WBEM is used by the Solaris Management
# Console (SMC).
#
# Refer to Section(s) 1.4.14.7 Page(s) 55-6 CIS Apple OS X 10.7 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::wbem::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::wbem": }
    }
  }
}

class pulsar::service::wbem::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == '5.10' {
        disable_service { "svc:/application/management/wbem": }
      }
    }
  }
}
