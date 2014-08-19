# pulsar::user::lockout
#
# The account lockout threshold specifies the amount of times a user can
# enter a wrong password before a lockout will occur.
# The account lockout feature prevents brute-force password attacks on
# the system.
#
# Refer to Section(s) 5.18 Page(s) 66-67 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_pwpolicy_maxFailedLoginAttempts

class pulsar::user::lockout::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::user::lockout": }
    }
  }
}

class pulsar::user::lockout::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel == "Darwin" {
      check_pwpolicy { "maxFailedLoginAttempts": value => "3" }
    }
  }
}
