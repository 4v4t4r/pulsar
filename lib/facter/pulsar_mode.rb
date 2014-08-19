# Set pulsar mode
#
# report         = Audit (no changes made)
# lockdown       = Lockdown (changes mage)
# detailedreport = Detailed Audit (Include Fix Information)
#
require 'facter'

Facter.add('pulsar_mode') do
  setcode do
    pulsar_mode = 'detailedreport'
  end
end

