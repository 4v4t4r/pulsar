# pulsar::accounting::sunos
#
# Check auditing setup on Solaris 11
# Need to investigate more auditing capabilities on Solaris 10
#.

# Needs finishing

class pulsar::accounting::sunos::init {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == "Solaris" {
      if $kernelrelease == "5.11" {
        init_message { "pulsar::accounting::sunos": }
      }
    }
  }
}

class pulsar::accounting::sunos::main {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == "Solaris" {
      if $kernelrelease == "5.11" {
      }
    }
  }
}
