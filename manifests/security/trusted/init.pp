# pulsar::security::trusted
#
# The recommendation is to implement TE to protect the system from Trojan
# horse style attacks. TE provides a robust system integrity checking process.
# One of the common ways a hacker infiltrates a system is through file
# tampering or the use of a Trojan horse. The implementation of TE can provide
# a number of integrity checks prior to loading a program into memory, any
# deviations can also be highlighted when programs and files are validated
# offline. This ensures that the programs executed are those which are intended
# to be and not malicious code masquerading as a true program.
# When a discrepancy is identified it is classified as either minor or major.
# A minor discrepancy is automatically reset to the value defined in the TSD.
# In the event of a major discrepancy the file access permissions are changed
# to make the file inaccessible.
# There is a pre-requisite requirement to install CLiC and SSL software.
#
# Refer to Section(s) 2.[14,15].1 Page(s) 226-229 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_trustchk_CHKEXEC
# Requires fact: pulsar_trustchk_CHKSCRIPT
# Requires fact: pulsar_trustchk_STOP_ON_CHKFAIL
# Requires fact: pulsar_trustchk_TE
# Requires fact: pulsar_trustchk_TEP

class pulsar::security::trusted::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "AIX" {
      init_message { "pulsar::security::trusted": }
      install_package { "clic.rte.lib": }
    }
  }
}

class pulsar::security::trusted::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "AIX" {
      $parameters = [ 'CHKEXEC', 'CHKSCRIPT', 'STOP_ON_CHKFAIL', 'TE', 'TEP' ]
      handle_aix_trustchk { $parameters: correct_value => "ON" }
    }
  }
}
