# pulsar::security::selinux
#
# Make sure SELinux is configured appropriately.
#
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 36-40,41-2 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 41-45,46-7 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 39-42,43-4 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_perms_etc_selinux_config
# Requires fact: pulsar_perms_etc_grub.conf
# Requires fact: pulsar_selinux
# Requires fact: pulsar_grub
# Requires fact: pulsar_installedpackages

class pulsar::security::selinux::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::security::selinux": }
    }
  }
}

class pulsar::security::selinux::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      check_perms { "/etc/selinux/config":
        mode  => "0400",
        owner => "root",
        group => "root",
      }
      $package_list = [ 'setroubleshoot', 'mctrans' ]
      uninstall_package { $package_list: }
      add_line_to_file { "SELINUX=enforcing": path => "selinux" }
      add_line_to_file { "SELINUXTYPE=targeted": path => "selinux" }
      add_line_to_file { "selinux=1": path => "grub" }
      add_line_to_file { "enforcing=1": path => "grub" }
    }
  }
}
