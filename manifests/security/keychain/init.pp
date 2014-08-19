# pulsar::security::keychain
#
# The keychain is a secure database store for passwords and certificates and
# is created for each user account on Mac OS X. The system software itself
# uses keychains for secure storage.
#
# While logged in, the keychain does not prompt the user for passwords for
# various systems and/or programs. This can be exploited by unauthorized users
# to gain access to password protected programs and/or systems in the absence
# of the user. Timing out the keychain can reduce the exploitation window.
#
# Refer to Section 5.2 Page(s) 49-50 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_security_show-keychain-info

class pulsar::security::keychain::init {
  if $pulsar_modules =~ /security|full/ {
    init_message { "pulsar::security::keychain": }
  }
}

class pulsar::security::keychain::main {
  if $pulsar_modules =~ /security|full/ {
    check_exec { "pulsar::security::keychain":
      check => "security show-keychain-info",
      exec  => "security set-keychain-settings -t 900s",
      value => "900s",
    }
  }
}
