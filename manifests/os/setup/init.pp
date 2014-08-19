# pulsar::os::setup
#
# Check ownership of /var/db/.AppleSetupDone
# Incorrect ownership could lead to tampering. If deleted the Administrator
# password will be reset on next boot.
#
# Refer to Section(s) 9.23 Page(s) 134-5 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_perms_var_db_.AppleSetupDone

class pulsar::os::setup::init {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::os::setup_init": }
    }
  }
}

class pulsar::os::setup::main {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel == "Darwin" {
      check_file_perms { "/var/db/.AppleSetupDone":
        mode  => "0400",
        owner => "root",
        group => "wheel",
      }
    }
  }
}
