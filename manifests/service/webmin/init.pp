# pulsar::service::webmin
#
# Webmin is a web-based system configuration tool for Unix-like systems,
# although recent versions can also be installed and run on Windows.
# With it, it is possible to configure operating system internals, such
# as users, disk quotas, services or configuration files, as well as modify
# and control open source apps, such as the Apache HTTP Server, PHP or MySQL.
#
# Turn off webmin if it is not being used.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::webmin::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::webmin": }
    }
  }
}

class pulsar::service::webmin::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        disable_service { "svc:/application/management/webmin:default": }
      }
    }
  }
}
