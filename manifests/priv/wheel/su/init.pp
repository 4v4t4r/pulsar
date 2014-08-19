# pulsar::priv::wheel::su
#
# Make sure su has a wheel group ownership
#.

# Requires fact: pulsar_perms_bin_su
# Requires fact: pulsar_perms_usr_sbin_su

class pulsar::priv::wheel::su::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::priv::wheel::su": }
    }
  }
}

class pulsar::priv::wheel::su::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        $file  = '/usr/sbin/su'
      }
      if $kernel == 'Linux' {
        $file  = '/bin/su'
      }
      check_perms { $file:
        mode  => "root",
        owner => "wheel",
        group => "4750",
      }
    }
  }
}
