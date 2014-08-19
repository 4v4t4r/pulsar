# pulsar::crypt::policy
#
# Set default cryptographic algorithms
#.

# Requires fact: pulsar_installedpackages
# Requires fact: pulsar_policy

class pulsar::crypt::policy::init {
  if $pulsar_modules =~ /crypt|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::crypt::policy": }
    }
  }
}

class pulsar::crypt::policy::main {
  if $pulsar_modules =~ /crypt|full/ {
    if $kernel == 'SunOS' {
      add_line_to_file { "CRYPT_DEFAULT=6": path => "policy" }
      add_line_to_file { "CRYPT_ALGORITHMS_ALLOW=6": path => "policy" }
    }
  }
}
