# pulsar::priv::events
#
# Auditing of Process and Privilege Events
#
# Refer to Section(s) 4.4 Page(s) 43-44 CIS Solaris 11.1 v1.0.0
#.

# Requires fact: pulsar_auditclass

class pulsar::priv::events::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.11" {
        init_message { "pulsar::priv::events": }
      }
    }
  }
}

class pulsar::priv::events::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.11" {
        $file_lines = [
          "lck:AUE_CHROOT", "lck:AUE_SETREUID", "lck:AUE_SETREGID",
          "lck:AUE_FCHROOT", "lck:AUE_PFEXEC", "lck:AUE_SETUID",
          "lck:AUE_NICE", "lck:AUE_SETGID", "lck:AUE_PRIOCNTLSYS",
          "lck:AUE_SETEGID", "lck:AUE_SETEUID", "lck:AUE_SETPPRIV",
          "lck:AUE_SETSID", "lck:AUE_SETPGID",
        ]
        add_line_to_file { $file_lines: path => "auditevent" }
      }
    }
  }
}
