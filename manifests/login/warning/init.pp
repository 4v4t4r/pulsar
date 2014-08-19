# pulsar::login::warning
#
# Displaying an access warning that informs the user that the system is reserved
# for authorized use only, and that the use of the system may be monitored, may
# reduce a casual attacker’s tendency to target the system.
#
# Refer to Section(s) 5.19 Page(s) 67-68 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.loginwindow_LoginwindowText

class pulsar::login::warning::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::login::warning": }
    }
  }
}

class pulsar::login::warning::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::login::warning::LoginwindowText":
        pfile => "com.apple.loginwindow",
        param => "LoginwindowText",
        value => "Authorised users only",
      }
    }
  }
}
