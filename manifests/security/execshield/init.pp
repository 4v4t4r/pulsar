# pulsar::security::execshield
#
# Execshield is made up of a number of kernel features to provide protection
# against buffer overflow attacks. These features include prevention of
# execution in memory data space, and special handling of text buffers.
#
# Enabling any feature that can protect against buffer overflow attacks
# enhances the security of the system.
#
# Refer to Section(s) 1.6.2 Page(s) 45-46 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.6.2,4 Page(s) 51,52-3 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.6.2 Page(s) 48 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 4.2 Page(s) 36-7 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages

# Needs fixing

class pulsar::security::execshield::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::security::execshield": }
    }
  }
}

class pulsar::security::execshield::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == 'Linux' {
      if $hardwareisa == 'i386' {
        if $osfamily =~ /CentOS|RedHat|SuSE/ {
          if $osfamily =~ /CentOS|RedHat/ {
            install_package { 'kernel-PAE': }
          }
          if $osfamily =~ /SuSE/ {
            install_package { 'kernel-pae': }
          }
          add_line_to_file { "kernel.exec-shield = 1": path => "sysctl" }
        }
      }
    }
  }
}
