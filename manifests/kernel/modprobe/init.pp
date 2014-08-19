# pulsar::kernel::modprobe
#
# Check entries are in place so kernel modules can't be force loaded.
# Some modules may getting unintentionally loaded that could reduce system
# security.

# Requires fact: pulsar_modprobe

class pulsar::kernel::modprobe::init {
  if $pulsar_modules =~ /kernel|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::kernel::modprobe": }
    }
  }
}

class pulsar::kernel::modprobe::main {
  if $pulsar_modules =~ /kernel|full/ {
    if $kernel == 'Linux' {
      $modprobe_lines = [ "install tipc /bin/true",
                          "install rds /bin/true",
                          "install sctp /bin/true",
                          "install dccp /bin/true" ]
      add_line_to_file { $modprobe_lines: path => "modprobe" }
    }
  }
}
