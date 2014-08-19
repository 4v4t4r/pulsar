# pulsar::service::x11::login
#
# The CDE login service provides the capability of logging into the system
# using  Xwindows. XDMCP provides the capability of doing this remotely.
# If XDMCP remote session access to a machine is not required at all,
# but graphical login access for the console is required, then
# leave the service in local-only mode.
#
# Most modern servers are rack mount so you will not be able to log
# into the console using X Windows anyway.
# Disabling these does not prevent support staff from running
# X Windows applications remotely over SSH.
#
# Running these commands will kill  any active graphical sessions
# on the console or using XDMCP. It will not kill any X Windows
# applications running via SSH.
#
# Refer to Section(s) 7.7 Page(s) 26 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.4 Page(s) 38 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.1 Page(s) 15 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.1.3 Page(s) 19 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices

# Needs to be fixed

class pulsar::service::x11::login::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::x11::login": }
    }
  }
}

class pulsar::service::x11::login::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease == '5.10' {
          $service_list = [ 'svc:/application/graphical-login/cde-login',
                           'svc:/application/gdm2-login' ]
          disable_service { $service_list: }
        }
        if $kernelrelease == '5.11' {
          disable_service { "svc:/application/graphical_login/gdm:default": }
        }
        if $kernelrelease =~ /6|7|8|9/ {
          disable_service { "dtlogin": }
        }
        # To be completed
      }
    }
    if $kernel == 'Linux' {
      # To be completed
    }
  }
}
