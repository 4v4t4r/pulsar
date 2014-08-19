# pulsar::service::cde::lock
#
# The default timeout for keyboard/mouse inactivity is 30 minutes before a
# password-protected screen saver is invoked by the CDE session manager.
# Many organizations prefer to set the default timeout value to 10 minutes,
# though this setting can still be overridden by individual users in their
# own environment.
#
# Refer to Section(s) 6.7 Page(s) 91-2 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_xsysresourcesfiles

class pulsar::service::cde::lock::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::cde::lock": }
    }
  }
}

class pulsar::service::cde::lock::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      add_cde_saver { $pulsar_sunos_xsysresourcesfiles: }
      add_cde_lock { $pulsar_sunos_xsysresourcesfiles: }
    }
  }
}
