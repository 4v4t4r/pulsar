# pulsar::service::epcc
#
# Password hints can give an attacker a hint as well, so the option to display
# hints should be turned off. If your organization has a policy to enter a help
# desk number in the password hints areas, do not turn off the option.
#
# Refer to Section 5.20 Page(s) 68-69 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::epcc::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::epcc": }
    }
  }
}

class pulsar::service::epcc::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      disable_service { "epcc": }
    }
  }
}
