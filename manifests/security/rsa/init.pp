# pulsar::security::rsa
#
# Check that RSA is installed
#.

# Requires fact: pulsar_pam

# Needs fixing

class pulsar::security::rsa::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::security::rsa": }
    }
  }
}

class pulsar::security::rsa::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux/ {
      check_rsa_securid { "pulsar::security::rsa": }
    }
  }
}

