# pulsar::login::logout
#
# Logging out occurs when a user intentionally closes off their access to a
# computer system. Automatic logout closes off a user's access without their
# consent after a period of inactivity.
#
# The risk of losing unsaved work is mitigated by disabling automatic logout.
#
# Refer to Section 5.11 Page(s) 57-58 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_.GlobalPreferences_com.apple.autologout.AutoLogOutDelay

class pulsar::login::logout::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::logout::auto": }
    }
  }
}

class pulsar::login::logout::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::login::logout::AutoLogOutDelay":
        pfile => ".GlobalPreferences",
        param => "com.apple.autologout.AutoLogOutDelay",
        value => "0"
      }
    }
  }
}
