# pulsar::login::auto
#
# having a computer automatically log in bypasses a major security feature
# (the login) and can allow a casual user access to sensitive data in that
# user’s home directory and keychain.
#
# Refer to Section(s) 1.4.13.5 Page(s) 47 CIS Apple OS X 10.6 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_.GlobalPreferences_com.apple.userspref.DisableAutoLogin

class pulsar::login::auto::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::login::auto::login": }
    }
  }
}

class pulsar::login::auto::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::login::auto":
        pfile => ".GlobalPreferences",
        param => "com.apple.userspref.DisableAutoLogin",
        value => "yes",
      }
    }
  }
}
