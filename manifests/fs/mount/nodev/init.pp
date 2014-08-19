# pulsar::fs::mount::nodev
#
# Check filesystems are mounted with nodev
#
# Prevents device files from being created on filesystems where they should
# not be created. This can stop possible vectors of attack and escalated
# privileges.
# Ignore / and /boot.
#
# Refer to Section(s) 1.1.2,4,10,11,14,16 Page(s) 15-25 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.2,4,10,11,14,16 Page(s) 16-26 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.2,4,10,11,14,16 Page(s) 16-26 CIS Red Hat Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.2,4,10,11,14,16 Page(s) 15-25 SLES 11 Benchmark v1.2.0
#.

# Requires fact: pulsar_fstab
# Requires fact: pulsar_configfile_fstab

class pulsar::fs::mount::nodev::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel =~ /Linux|SunOS|FreeBSD/ {
      init_message { "pulsar::fs::mount::nodev": }
    }
  }
}

class pulsar::fs::mount::nodev::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "Linux" {
      check_mounts { "nodev": }
    }
  }
}
