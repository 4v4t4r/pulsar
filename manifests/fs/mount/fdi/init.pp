# audit_mount_fdi
#
# User mountable file systems on Linux.
#
# This can stop possible vectors of attack and escalated privileges.
#.

# Requires fact: pulsar_floppycdromfdi
# Requires fact: pulsar_configfile_floppycdromfdi
# Requires fact: pulsar_perms_configfile_floppycdromfdi

# Needs to be fixed

class pulsar::fs::mount::fdi::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::fs::mount::fdi": }
    }
  }
}

class pulsar::fs::mount::fdi::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "Linux" {
      check_fdi { "pulsar::fs::mount::fdi": }
    }
  }
}
