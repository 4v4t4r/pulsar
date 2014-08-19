# Set pulsar filesystem search mode
#
# If set to yes, filesystem searches will be done
# This is disabled by default as it takes time
# To enable searches set to yes
# If using the template you will also need to enable searches in the template

require 'facter'

Facter.add('pulsar_filesystemsearch') do
  setcode do
    pulsar_filesystemsearch = 'no'
  end
end
