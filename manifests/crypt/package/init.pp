# pulsar::crypt::package
#
# The Solaris 10 Encryption Kit contains kernel modules that implement
# various encryption algorithms for IPsec and Kerberos, utilities that
# encrypt and decrypt files from the command line, and libraries with
# functions that application programs call to perform encryption.
# The Encryption Kit enables larger key sizes (> 128) of the following
# algorithms:
#
# AES (128, 192, and 256-bit key sizes)
# Blowfish (32 to 448-bit key sizes in 8-bit increments)
# RCFOUR/RC4 (8 to 2048-bit key sizes)
#
# This action is not needed for systems running Solaris 10 08/07 and newer
# as the Solaris 10 Encryption Kit is installed by default.
#.

# Requires fact: pulsar_installedpackages
# Requires fact: pulsar_operatingsystemupdate

class pulsar::crypt::package::init {
  if $pulsar_modules =~ /crypt|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::crypt::package": }
    }
  }
}

class pulsar::crypt::package::main {
  if $pulsar_modules =~ /crypt|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        check_crypt_package { "pulsar::crypt::package": }
      }
    }
  }
}
