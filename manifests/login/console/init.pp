# pulsar::login::console
#
# Privileged access to the system via the root account must be accountable
# to a particular user. The system console is supposed to be protected from
# unauthorized access and is the only location where it is considered
# acceptable # to permit the root account to login directly, in the case of
# system emergencies. This is the default configuration for Solaris.
# Use an authorized mechanism such as RBAC, the su command or the freely
# available sudo package to provide administrative access through unprivileged
# accounts. These mechanisms provide at least some limited audit trail in the
# event of problems.
# Note that in addition to the configuration steps included here, there may be
# other login services (such as SSH) that require additional configuration to
# prevent root logins via these services.
# A more secure practice is to make root a "role" instead of a user account.
# Role Based Access Control (RBAC) is similar in function to sudo, but provides
# better logging ability and additional authentication requirements. With root
# defined as a role, administrators would have to login under their account and
# provide root credentials to invoke privileged commands. This restriction also
# includes logging in to the console, except for single user mode.
#
# Refer to Section(s) 6.4 Page(s) 142-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.4 Page(s) 165 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.4 Page(s) 145 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.3.4 Page(s) 134-5 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.14 Page(s) 57 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.10 Page(s) 95-6 CIS Solaris 10 v5.1.0
#.

# Needs fixing

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_login
# Requires fact: pulsar_securetty

class pulsar::login::console::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::login::console": }
    }
  }
}

class pulsar::login::console::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Linux" {
      check_securetty {"pulsar::login::console": }
    }
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        add_line_to_file { "CONSOLE=/dev/console": path => "login" }
      }
      if $kernelrelease == "5.11" {
        $console_service_list = [ 'svc:/system/console-login:terma', 'svc:/system/console-login:termb' ]
        disable_service { $console_service_list: }
      }
    }
  }
}
