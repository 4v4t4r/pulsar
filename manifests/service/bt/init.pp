# pulsar::service::bt
#
# Bluetooth can be very useful, but can also expose a Mac to certain risks.
# Unless specifically needed and configured properly, Bluetooth should be
# turned off.
# Bluetooth internet sharing can expose a Mac and the network to certain
# risks and should be turned off.
# Unless you are using a Bluetooth keyboard or mouse in a secure environment,
# there is no reason to allow Bluetooth devices to wake the computer.
# An attacker could use a Bluetooth device to wake a computer and then
# attempt to gain access.
#
# Refer to Section(s) 2.1.1 Page(s) 8-11 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_defaults_com.apple.Bluetooth_ControllerPowerState
# Requires fact: pulsar_defaults_com.apple.Bluetooth_PANServices
# Requires fact: pulsar_defaults_com.apple.Bluetooth_BluetoothSystemWakeEnable

class pulsar::service::bt::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::bt": }
    }
  }
}

class pulsar::service::bt::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      $pfile_name = "com.apple.Bluetooth"
      check_defaults { "pulsar::service::bt::ControllerPowerState":
        pfile => $pfile_name,
        param => "ControllerPowerState",
        value => "0",
      }
      check_defaults { "pulsar::service::bt::PANServices":
        pfile => $pfile_name,
        param => "PANServices",
        value => "0",
      }
      check_defaults { "pulsar::service::bt::BluetoothSystemWakeEnable":
        pfile => $pfile_name,
        param => "BluetoothSystemWakeEnable",
        value => "0",
      }
    }
  }
}
