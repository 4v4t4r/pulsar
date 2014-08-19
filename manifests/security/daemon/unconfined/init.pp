# pulsar::security::daemon::unconfined
#
# Daemons that are not defined in SELinux policy will inherit the security
# context of their parent process.
#
# Refer to Section(s) 1.4.6 Page(s) 40 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.4.6 Page(s) 45-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.4.6 Page(s) 43 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_unconfineddaemons

class pulsar::security::daemon::unconfined::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::security::daemon::unconfined": }
    }
  }
}

class pulsar::security::daemon::unconfined::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      check_unconfined_daemons { "pulsar::security::daemon::unconfined": }
    }
  }
}
