# pulsar::priv::wheel::sudo
#
# Check wheel group settings in sudoers
#.

# Requires fact: pulsar_perms_etc_sudoers
# Requires fact: pulsar_perms_etc_sudoers.d
# Requires fact: pulsar_perms_etc_sudoers.d_wheel
# Requires fact: pulsar_sudoers
# Requires fact: pulsar_sudoerswheel
# Requires fact: pulsar_exists_etc_sudoers.d
# Requires fact: pulsar_exists_etc_sudoers.d_wheel

# Needs fixing

class pulsar::priv::wheel::sudo::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux|SunOS|Darwin/ {
      init_message { "pulsar::priv::wheel::sudo": }
      if $pulsar_mode !~ /report/ {
        file { '/etc/sudoers.d':
          ensure => directory,
          owner  => 'root',
          group  => 'root',
          mode   => '750',
        }
      }
    }
  }
}

class pulsar::priv::wheel::sudo::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux|SunOS|Darwin/ {
      check_file_perms { "/etc/sudoers":
        mode  => "0440",
        owner => "root",
        group => "root",
      }
      check_dir_perms { "/etc/sudoers.d":
        mode  => "0440",
        owner => "root",
        group => "root",
      }
      check_file_perms { "/etc/sudoers.d/wheel":
        mode  => "0440",
        owner => "root",
        group => "root",
      }
      add_line_to_file { "#includedir /etc/sudoers.d": path => "sudoers" }
      add_line_to_file { "wheel ALL=(ALL) PASSWD:ALL": path => "sudoerswheel" }
    }
  }
}

