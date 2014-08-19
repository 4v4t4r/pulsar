# pulsar::security::grub
#
# GRUB is a boot loader for x86/x64 based systems that permits loading an OS
# image from any location. Oracle x86 systems support the use of a GRUB Menu
# password for the console.
# The flexibility that GRUB provides creates a security risk if its
# configuration is modified by an unauthorized user. The failsafe menu entry
# needs to be secured in the same environments that require securing the
# systems firmware to avoid unauthorized removable media boots. Setting the
# GRUB Menu password helps prevent attackers with physical access to the
# system console from booting off some external device (such as a CD-ROM or
# floppy) and subverting the security of the system.
# The actions described in this section will ensure you cannot get to failsafe
# or any of the GRUB command line options without first entering the password.
# Note that you can still boot into the default OS selection without a password.
#.

# Requires fact: pulsar_grub
# Requires fact: pulsar_perms_configfile_grub
# Requires fact: pulsar_perms_configfile_grub

# Needs to be fixes

class pulsar::security::grub::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::security::grub": }
    }
  }
}

class pulsar::security::grub::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux/ {
      check_perms { "grub":
        owner => 'root',
        group => 'root',
        mode  => '600',
      }
      check_grub_password { "pulsar::security::grub": }
    }
  }
}
