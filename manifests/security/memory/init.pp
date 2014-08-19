# pulsar::security::memory
#
# Set the system flag to force randomized virtual memory region placement.
#
# Randomly placing virtual memory regions will make it difficult for to write
# memory page exploits as the memory placement will be consistently shifting.
#
# Refer to Section(s) 1.6.3 Page(s) 46 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.6.3 Page(s) 51-2 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.6.3 Page(s) 48-9 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 4.3 Page(s) 37 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_sysctl

class pulsar::security::memory::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /CentOS|Red/ {
        init_message { "pulsar::security::memory": }
      }
    }
  }
}

class pulsar::security::memory::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /CentOS|Red/ {
        add_line_to_file { "kernel.randomize_va_space = 2": path => "sysctl" }
      }
    }
  }
}
