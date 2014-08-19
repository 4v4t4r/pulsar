# pulsar::accounting::kernel
#
# Kernel-level auditing provides information on commands and system calls that
# are executed on the local system. The audit trail may be reviewed with the
# praudit command. Note that enabling kernel-level auditing on Solaris disables
# the automatic mounting of external devices via the Solaris volume manager
# daemon (vold).
# Kernel-level auditing can consume a large amount of disk space and even cause
# system performance impact, particularly on heavily used machines.
#.

# Requires fact: pulsar_system
# Requires fact: pulsar_auditcontrol
# Requires fact: pulsar_audituser

class pulsar::accounting::kernel::init {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == 'SunOS' {
      init_message { "pulsar::accounting::kernel": info => $pulsar_info_accounting_kernel }
    }
  }
}

class pulsar::accounting::kernel::main {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == 'SunOS' {
      add_line_to_file { "set c2audit:audit_load = 1": path => "system" }
      add_line_to_file { "flags:lo,ad,cc": path => "auditcontrol" }
      add_line_to_file { "naflags:lo,ad,ex": path => "auditcontrol" }
      add_line_to_file { "minfree:20": path => "auditcontrol" }
      add_line_to_file { "root:lo,ad:no": path => "audituser" }
    }
  }
}
