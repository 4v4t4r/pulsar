# pulsar::accounting::process
#
# Enable process accounting at boot time
# Process accounting logs information about every process that runs to
# completion on the system, including the amount of CPU time, memory, etc.
# consumed by each process.
#
# Refer to Section(s) 10.1 Page(s) 137-8 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_startupservices

class pulsar::accounting::process::init {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::accounting::process": }
    }
  }
}

class pulsar::accounting::process::main {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease !~ /11/ {
        enable_startup_service { "acct": }
      }
    }
  }
}

