# pulsar::priv::class
#
# Creating Audit Classes improves the auditing capabilities of Solaris.
#
# Refer to Section(s) 4.1-5 Page(s) 39-45 CIS Solaris 11.1 v1.0.0
#.

# Requires fact: pulsar_auditclass

class pulsar::priv::class::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.11" {
        init_message { "pulsar::priv::class": }
      }
    }
  }
}

class pulsar::priv::class::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease == "5.11" {
        add_line_to_file { "0x0100000000000000:lck:Security Lockdown": path => "audtclass" }
      }
    }
  }
}
