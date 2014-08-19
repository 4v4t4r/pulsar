# pulsar::security::keyboard
#
# Enabling Secure Keyboard Entry minimizes the risk of a key logger from
# detecting what is entered in Terminal.
#
# Refer to Section 2.8 Page(s) 33 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_Terminal_SecureKeyboardEntry

class pulsar::security::keyboard::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::security::keyboard": }
    }
  }
}

class pulsar::security::keyboard::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::security::keyboard::SecureKeyboardEntry":
        pfile => "Terminal",
        param => "SecureKeyboardEntry",
        value => "1",
      }
    }
  }
}
