# pulsar::user:root
#
# Enabling the root account puts the system at risk since any exploit would
# have unlimited access privileges within the system. Using the sudo command
# allows users to perform functions as a root user while limiting and password
# protecting the access privileges.
#
# Refer to Section(s) 5.3 Page(s) 50-51 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 8.5 Page(s) 28 CIS FreeBSD Benchmark v1.0.5
#.

# Requires fact: pulsar_userlist
# Requires fact: pulsar_dscl_root_AuthenticationAuthority

class pulsar::user::root::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /Darwin|FreeBSD/ {
      init_message { "pulsar::user:root": }
    }
  }
}

class pulsar::user::root::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /Darwin|FreeBSD/ {
      if $kernel == "Darwin" {
        check_dscl { "pulsar::user:root::AuthenticationAuthority":
          user  => "root",
          param => "AuthenticationAuthority",
          value => "Yes",
        }
      }
      if $kernel == "FreeBSD" {
        disable_user { "toor": reason => "Invalid account" }
      }
    }
  }
}
