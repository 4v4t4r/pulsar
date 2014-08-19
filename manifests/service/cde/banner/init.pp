# pulsar::service::cde::banner
#
# The Common Desktop Environment (CDE) provides a uniform desktop environment
# for users across diverse Unix platforms.
# Warning messages inform users who are attempting to login to the system of
# their legal status regarding the system and must include the name of the
# organization that owns the system and any monitoring policies that are in
# place. Consult with your organization's legal counsel for the appropriate
# wording for your specific organization.
#
# Refer to Section(s) 8.2 Page(s) 112-3 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_xresourcesfiles

# Needs more work

class pulsar::service::cde::banner::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::cde::banner": }
    }
  }
}
class pulsar::service::cde::banner::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      $file_list = split( $pulsar_xresourcesfiles,",")
      add_cde_banner {$file_list: }
    }
  }
}
