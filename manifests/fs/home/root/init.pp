# pulsar::fs::home::root
#
# By default, the Solaris OS root user's home directory is "/".
# Changing the home directory for the root account provides segregation from
# the OS distribution and activities performed by the root user. A further
# benefit is that the root home directory can have more restricted permissions,
# preventing viewing of the root system account files by non-root users.
#
# Refer to Section(s) 7.5 Page(s) 105-6 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_homedir_root
# Requires fact: pulsar_perms_root

class pulsar::fs::home::root::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::fs::home::root": }
      check_dir_perms { "/root":
        mode  => "0700",
        owner => "root",
        group => "root",
      }
    }
  }
}

class pulsar::fs::home::root::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "SunOS" {
      check_home_dir { "root":
        path => "/root",
      }
    }
  }
}

