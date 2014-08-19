# pulsar::user::reserved
#
# Traditionally, Unix systems establish "reserved" UIDs (0-99 range) that are
# intended for system accounts.
# If a user is assigned a UID that is in the reserved range, even if it is not
# presently in use, security exposures can arise if a subsequently installed
# application uses the same UID.
#
# Refer to Section(s) 9.2.17 Page(s) 202-3 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.17 Page(s) 84-5 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.17 Page(s) 130-1 CIS Solaris 10 v1.1.0
#.

# Require fact: pulsar_userswithreservedids

class pulsar::user::reserved::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::user::reserved": }
    }
  }
}

class pulsar::user::reserved::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux/ {
      check_reserved_uids { "pulsar::user::reserved": }
    }
  }
}
