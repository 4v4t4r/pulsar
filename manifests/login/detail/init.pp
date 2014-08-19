# pulsar::login::detail
#
# Displaying the names of the accounts on the computer may make breaking in
# easier. Force the user to enter a login name and password to log in.
#
# Refer to Section 6.1.1 Page(s) 72-73 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.loginwindow_SHOWFULLNAME

class pulsar::login::detail::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::login::detail": }
    }
  }
}

class pulsar::login::detail::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::login::detail::SHOWFULLNAME":
        pfile => "com.apple.loginwindow",
        param => "SHOWFULLNAME",
        value => "yes",
      }
    }
  }
}
