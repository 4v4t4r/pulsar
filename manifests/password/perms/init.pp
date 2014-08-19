# that is critical to the security of those accounts, such as the hashed
# password and other security information.
#
# The /etc/gshadow file contains information about group accounts that is
# critical to the security of those accounts, such as the hashed password and
# other security information.
#
# The /etc/group file contains a list of all the valid groups defined in the
# system. The command below allows read/write access for root and read access
# for everyone else.
#
# Refer to Section(s) 9.1.2-9 Page(s) 153-9 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.2-9 Page(s) 177-183 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.2-9 Page(s) 157-162 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 12.2-7 Page(s) 146-150 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.1 Page(s) 21 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.1-3 Page(s) 192-4 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_perms_etc_group
# Requires fact: pulsar_perms_etc_passwd
# Requires fact: pulsar_perms_etc_gshadow
# Requires fact: pulsar_perms_etc_shadow

class pulsar::password::perms::init {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel =~ /Linux|SunOS/ {
      init_message { "pulsar::password::perms": }
    }
  }
}

class pulsar::password::perms::main {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel =~ /Linux|SunOS/ {
      if $kernel == "Linux" {
        check_file_perms { '/etc/group':
          fact  => $pulsar_perms_etc_group,
          owner => 'root',
          group => 'root',
          mode  => '0644',
        }
        check_file_perms { '/etc/passwd':
          fact  => $pulsar_perms_etc_passwd,
          owner => 'root',
          group => 'root',
          mode  => '0644',
        }
        check_file_perms { '/etc/gshadow':
          fact  => $pulsar_perms_etc_gshadow,
          owner => 'root',
          group => 'root',
          mode  => '0000',
        }
        check_file_perms { '/etc/shadow':
          fact  => $pulsar_perms_etc_shadow,
          owner => 'root',
          group => 'root',
          mode  => '0000',
        }
      }
      if $kernel == "SunOS" {
        check_file_perms { '/etc/group':
          fact  => $pulsar_perms_etc_group,
          owner => 'root',
          group => 'sys',
          mode  => '0644',
        }
        check_file_perms { '/etc/passwd':
          fact  => $pulsar_perms_etc_passwd,
          owner => 'root',
          group => 'sys',
          mode  => '0644',
        }
        check_file_perms { '/etc/shadow':
          fact  => $pulsar_perms_etc_shadow,
          owner => 'root',
          group => 'sys',
          mode  => '0400',
        }
      }
    }
  }
}
