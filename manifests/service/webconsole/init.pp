# pulsar::service::webconsole
#
# The Java Web Console (smcwebserver(1M)) provides a common location
# for users to access web-based system management applications.
#
# Refer to Section(s) 2.1.5 Page(s) 20-1 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::webconsole::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::webconsole": }
    }
  }
}

class pulsar::service::webconsole::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == '5.10' {
        disable_service { "svc:/system/webconsole:console": }
      }
    }
  }
}
