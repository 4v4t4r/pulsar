# pulsar::service::biosdevname
#
# YaST2 automatically installs biosdevname, if YaST2 auto-detects hardware
# compatible with biosdevname. biosdevname uses three methods to determine
# NIC names:
#
# 1. PCI firmware spec.3.1
# 2. smbios (matches # after "em" to OEM # printed on board or housing)
# 3. PCI IRQ Routing Table (uses # of NIC position in the device history).
#    If the BIOS does not support biosdevname, no NICs' are re-named.
#
# biosdevname is an external tool that works with the udev framework for
# naming devices. The feature can automatically be installed if YaST2 detects
# compatible hardware with biosdevname. biosdevname can also be enabled or
# disabled by using the kernel command line. biosdevname is an external tool
# that works with the udev framework for custom re- naming of system hardware
# connections made by the kernel and BIOS. As allowing the re- naming of
# devices can severely disrupt network communications by creating resource
# conflicts and provide an attack vector for denial of service exploits, this
# capability should be disabled or restricted according to the needs of the
# organization.
#
# Refer to Section(s) 6.17 Page(s) 64 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages

class pulsar::service::biosdevname::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      if $lsbdiskid =~ /SuSE/ {
        init_message { "pulsar::service::biosdevname": }
      }
    }
  }
}

class pulsar::service::biosdevname::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      if $lsbdiskid =~ /SuSE/ {
        uninstall_package { "biosdevname": }
      }
    }
  }
}
