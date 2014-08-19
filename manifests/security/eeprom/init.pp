# pulsar::security::eeprom
#
# Oracle SPARC systems support the use of a EEPROM password for the console.
# Setting the EEPROM password helps prevent attackers with physical access to
# the system console from booting off some external device (such as a CD-ROM
# or floppy) and subverting the security of the system.
#
# Refer to Section(s) 6.15 Page(s) 59-60 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.12 Page(s) 97-8 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_eeprom

class pulsar::security::eeprom::init {
  if $pulsar_modules =~ /security|full/ {
    init_message { "pulsar::security::eeprom": }
  }
}

class pulsar::security::eeprom::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == 'SunOS' and $architecture == 'sparc' {
      check_eeprom_security { "pulsar::security::eeprom": }
    }
  }
}
