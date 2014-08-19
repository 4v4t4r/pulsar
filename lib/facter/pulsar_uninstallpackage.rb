# Set pulsar package uninstall mode

# If set to yes, packages will be uninstalled

require 'facter'

Facter.add('pulsar_uninstallpackage') do
  setcode do
    pulsar_uninstallpackage = 'no'
  end
end
