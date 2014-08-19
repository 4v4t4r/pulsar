# pulsar::fs::partition
#
# Check filesystems are on separate partitions
#
# Refer to Section(s) 1.1.1,5,7,8,9 Page(s) 14-21 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.1,5,7,8,9 Page(s) 15-22 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.1,5,7,8,9 Page(s) 18-26 CIS Red Hat Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1,5,7,8,9 Page(s) 14-21 SLES 11 Benchmark v1.2.0
#.

# Requires fact: pulsar_fstab

class pulsar::fs::partition::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::fs::partition": }
    }
  }
}

class pulsar::fs::partition::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "Linux" {
      check_partition_exists { "/tmp": fact => $pulsar_partition_tmp }
      check_partition_exists { "/home": fact => $pulsar_partition_home }
      check_partition_exists { "/var": fact => $pulsar_partition_var }
      check_partition_exists { "/var/log": fact => $pulsar_partition_var_log }
    }
  }
}
