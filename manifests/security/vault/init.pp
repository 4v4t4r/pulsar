# pulsar::security::vault
#
# Encrypting sensitive data minimizes the likelihood of unauthorized users
# gaining access to it.
#
# Refer to Section 2.6.1 Page(s) 28 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_bootdisk
# Requires fact: pulsar_corestorage_encryption_status

class pulsar::security::vault::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::security::vault": }
    }
  }
}

class pulsar::security::vault::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      check_exec { "pulsar::security::vault::Locked":
        fact  => $pulsar_corestorage_encryption_status,
        check => "diskutil cs list",
        exec  => "Open System Preferences, Select Security & Privacy, Select FileVault, Select Turn on FileVault",
        value => "Locked",
      }
    }
  }
}
