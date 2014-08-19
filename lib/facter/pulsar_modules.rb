# Set  modules mode
#
# This specifies which modules to run

require 'facter'

Facter.add('pulsar_modules') do
  setcode do
    pulsar_modules = 'user'
  end
end
