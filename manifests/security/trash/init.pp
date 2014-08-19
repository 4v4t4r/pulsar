# pulsar::security::trash
#
# Configuring Secure Empty Trash mitigates the risk of an admin user on the
# system recovering sensitive files that the user has deleted. It is possible
# for anyone with physical access to the device to get access if FileVault is
# not used.
#
# Refer to Section 2.8 Page(s) 33 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.finder_EmptyTrashSecurely

class pulsar::security::trash::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::security::trash": }
    }
  }
}

class pulsar::security::trash::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::security::trash::EmptyTrashSecurely":
        pfile => "com.apple.finder",
        param => "EmptyTrashSecurely",
        value => "1",
      }
    }
  }
}
