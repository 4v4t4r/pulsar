# pulsar::fs::mount::noexec
#
# The noexec mount option specifies that the filesystem cannot contain
# executable binaries.
# Since the /tmp filesystem is only intended for temporary file storage, set
# this option to ensure that users cannot run executable binaries from /tmp.
#
# Refer to Section(s) 1.1.4 Page(s) 14-5 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.4 Page(s) 17-8 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.4 Page(s) 16-7 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_fstab
# Requires fact: pulsar_configfile_fstab

class pulsar::fs::mount::noexec::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::fs::mount::noexec": }
    }
  }
}

class pulsar::fs::mount::noexec::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "Linux" {
      check_mounts { "noexec": }
    }
  }
}
