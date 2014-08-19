# pulsar::security::issue
#
# The contents of the /etc/issue file are displayed prior to the login prompt
# on the system's console and serial devices, and also prior to logins via
# telnet. /etc/motd is generally displayed after all successful logins, no
# matter where the user is logging in from, but is thought to be less useful
# because it only provides notification to the user after the machine has been
# accessed.
# Warning messages inform users who are attempting to login to the system of
# their legal status regarding the system and must include the name of the
# organization that owns the system and any monitoring policies that are in
# place. Consult with your organization's legal counsel for the appropriate
# wording for your specific organization.
#.

# Requires fact: pulsar_issue

class pulsar::security::issue::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|FreeBSB|AIX/ {
      init_message { "pulsar::security::issue": }
    }
  }
}

class pulsar::security::issue::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|FreeBSB|AIX/ {
      check_issue { "pulsar::security::issue": }
    }
  }
}
