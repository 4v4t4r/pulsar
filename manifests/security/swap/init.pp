# pulsar::security::swap
#
# Passwords and other sensitive information can be extracted from insecure
# virtual memory, so it’s a good idea to secure virtual memory. If an attacker
# gained control of the Mac, the attacker would be able to extract user names
# and passwords or other kinds of data from the virtual memory swap files.
#
# Refer to Section(s) 1.4.13.6 Page(s) 47-8 CIS Apple OS X 10.6 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.virtualMemory_UseEncryptedSwap

class pulsar::security::swap::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::security::swap": }
    }
  }
}

class pulsar::security::swap::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::security::swap::UseEncryptedSwap":
        pfile => "com.apple.virtualMemory",
        param => "UseEncryptedSwap",
        value => "yes",
      }
    }
  }
}
