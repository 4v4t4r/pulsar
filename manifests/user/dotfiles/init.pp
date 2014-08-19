# pulsar::user::dotfiles
#
# While the system administrator can establish secure permissions for users'
# "dot" files, the users can easily override these.
# Group or world-writable user configuration files may enable malicious users to
# steal or modify other users' data or to gain another user's system privileges.
#
# Refer to Section(s) 9.2.8 Page(s) 167-168 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.8 Page(s) 193-4 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 13.8 Page(s) 159 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.2 Page(s) 25 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 9.8 Page(s) 77-8 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.8 Page(s) 122 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_readabledotfiles

class pulsar::user::dotfiles::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
      init_message { "pulsar::user::dotfiles": }
    }
  }
}

class pulsar::user::dotfiles::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
      check_user_files { "readabledot": }
    }
  }
}
