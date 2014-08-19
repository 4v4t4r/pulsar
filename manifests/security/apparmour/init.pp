# pulsar::security::apparmour
#
# AppArmour provides a Mandatory Access Control (MAC) system that greatly
# augments the default Discretionary Access Control (DAC) model.
# For an action to occur, both the traditional DAC permissions must be
# satisfied as well as the AppArmor MAC rules. The action will not be
# allowed if either one of these models does not permit the action.
# In this way, AppArmor rules can only make a system's permissions more
# restrictive and secure.
#
# Refer to Section(s) 4.5 Page(s) 38-9 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages

class pulsar::security::apparmour::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /SuSE/ {
        init_message { "pulsar::security::apparmour": }
        install_package { "apparmour": }
      }
    }
  }
}

# Need to write a module to handle text better

# Need to code this better

class pulsar::security::apparmour::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /SuSE/ {
        handle_exec { 'apparmour_enable':
          fix   => 'cat /boot/grub/menu.lst |sed "s/apparmour=0//g" > /tmp/apparmour ; cat /tmp/apparmour > /boot/grub/menu.lst ; rm /tmp/apparmour ; enforce /etc/apparmor.d/*',
          check => 'cat /boot/grub/menu.lst |grep "apparmour=0" |head -1 |wc -l |grep "^0$"',
          value => "",
        }
      }
    }
  }
}
