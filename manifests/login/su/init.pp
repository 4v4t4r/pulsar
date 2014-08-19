# pulsar::login::su
#
# Check single user mode requires password.
#
# With remote console access it is possible to gain access to servers as though
# you were in front of them, therefore entering single user mode should require
# a password.
#
# On later releases of Linux using systemd check for the presence of
# /etc/systemd/system/ctrl-alt-del.target
#
# Refer to Section(s) 1.5.4-5 Page(s) 43-44 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.2 Page(s) 9 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 3.4 Page(s) 33-4 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.5.4-5 Page(s) 48-9 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.5.4-4 Page(s) 45-6 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_inittab
# Requires fact: pulsar_exists_etc_systemd_system_ctrl_alt_del_target

# Needs fixing

class pulsar::login::su::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::login::su": }
    }
  }
}

class pulsar::login::su::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Linux" {
      check_sulogin { "pulsar::login::su": }
    }
  }
}
