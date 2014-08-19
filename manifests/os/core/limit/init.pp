# pulsar::os::core::limit
#
# When an application encounters a runtime error the operating system has the
# opportunity to dump the application’s state, including memory contents, to
# disk. This operation is called a core dump. It is possible for a core dump
# to contain sensitive information, including passwords. Therefore it is
# recommended that core dumps be disabled in high security scenarios.
#
# Refer to Section(s) 2.10 Page(s) 34-35 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_exec_launchctl_limit_core

class pulsar::os::core::limit::init {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::os::core::limit": }
    }
  }
}

class pulsar::os::core::limit::main {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel == "Darwin" {
      check_exec { "pulsar::os::core::limit":
        fact  => $pulsar_exec_launchctl_limit_core,
        check => "launchctl limit core",
        exec  => "launchctl limit core 0",
        value => "  core        0              0              ",
      }
    }
  }
}
