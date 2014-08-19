# pulsar::service::nis::entries
#
# The character + in various files used to be markers for systems to insert
# data from NIS maps at a certain point in a system configuration file.
# These entries are no longer required on Solaris systems, but may exist in
# files that have been imported from other platforms.
# These entries may provide an avenue for attackers to gain privileged access
# on the system.
#
# Refer to Section(s) 9.2.2-4 Page(s) 163-5 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.2-4 Page(s) 188-190 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.2-4 Page(s) 166-8 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 13.2-4 Page(s) 154-6 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 9.4 Page(s) 118-9 CIS Solaris 10 v1.1.0
#.

# Needs code for handle_nis_entries

# Requires fact: pulsar_nisgroupentries
# Requires fact: pulsar_nispasswordentries

class pulsar::service::nis::entries::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::nis::entries": }
    }
  }
}

class pulsar::service::nis::entries::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      check_nis_entries { "group": }
      check_nis_entries { "passwd": }
    }
  }
}
