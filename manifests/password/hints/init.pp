# pulsar::password::hints
#
# Password hints are user created text displayed when an incorrect password i
# used for an account.
# Password hints make it easier for unauthorized persons to gain access to
# systems by providing information to anyone that the user provided to assist
# remembering the password. This info could include the password itself or
# other information that might be readily discerned with basic knowledge of
# the end user.
#
# Refer to Section 6.1.2 Page(s) 73-74 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.loginwindow_RetriesUntilHint

class pulsar::password::hints::init {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::password::hints": }
    }
  }
}

class pulsar::password::hints::main {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::password::hints::RetriesUntilHint":
        fact  => $pulsar_defaults_com_apple_loginwindow_retriesuntilhint,
        pfile => "com.apple.loginwindow",
        param => "RetriesUntilHint",
        value => "0",
      }
    }
  }
}
