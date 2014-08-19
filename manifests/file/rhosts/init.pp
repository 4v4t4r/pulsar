# pulsar::file::rhosts
#
# The /.rhosts, /.shosts, and /etc/hosts.equiv files enable a weak form of
# access control. Attackers will often target these files as part of their
# exploit scripts. By linking these files to /dev/null, any data that an
# attacker writes to these files is simply discarded (though an astute
# attacker can still remove the link prior to writing their malicious data).
#
# Refer to Section(s) 1.5.2 Page(s) 102-3 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_shostsfiles
# Requires fact: pulsar_rhostsfiles
# Requires fact: pulsar_hostsequivfiles

class pulsar::file::rhosts::init {
  if $pulsar_modules =~ /file|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|Darwin|AIX/ {
      init_message { "pulsar::file::rhosts": }
    }
  }
}

class pulsar::file::rhosts::main {
  if $pulsar_modules =~ /file|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|Darwin|AIX/ {
      check_user_files { "rhosts": }
      check_user_files { "shosts": }
      check_user_files { "hostequiv": }
    }
  }
}
