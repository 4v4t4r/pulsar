# pulsar::security::screensaver
#
# Sometimes referred to as a screen lock this option will keep the casual user
# away from your Mac when the screen saver has started.
# If the machine automatically logs out, unsaved work might be lost. The same
# level of security is available by using a Screen Saver and the
# "Require a password to wake the computer from sleep or screen saver" option.
#
# Refer to Section 2.3.1-2 Page(s) 13-14 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 5.5 Page(s) 51-52 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.screensaver_askForPassword
# Requires fact: pulsar_defaults_com.apple.screensaver_idleTime

class pulsar::security::screensaver::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::security::screensaver": }
    }
  }
}

class pulsar::security::screensaver::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "darwin" {
      check_defaults { "pulsar::security::screensaver::askForPassword":
        pfile => "com.apple.screensaver",
        param => "askForPassword",
        value => "1",
      }
      check_defaults { "pulsar::security::screensaver::idleTime":
        pfile => "com.apple.screensaver",
        param => "idleTime",
        value => "900",
      }
    }
  }
}
