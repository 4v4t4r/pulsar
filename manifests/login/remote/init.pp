# pulsar::login::remote
#
# Disabling Remote Login mitigates the risk of an unauthorized person gaining
# access to the system via Secure Shell (SSH). Additionally, the scope of the
# benchmark is for Apple OSX clients, not servers.
# This check is only run on clients, not servers.
#
# Refer to Section 2.4.5 Page(s) 20-21 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::login::remote::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::login::remote": }
    }
  }
}

class pulsar::login::remote::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      disable_service { "ssh": }
    }
  }
}
