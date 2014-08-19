# pulsar::service::shell
#
# Turn off remote shell services
#
# AIX:
#
# /etc/security/user - rlogin:
#
# Defines whether or not the root user can login remotely.
# In setting the rlogin attribute to false, this ensures that the root user
# cannot remotely log into the system. All remote logins as root should be
# prohibited, instead elevation to root should only be allowed once a user
# has authenticated locally through their individual user account.
#
# System account lockdown:
#
# This change disables direct login access for the generic system accounts
# i.e. daemon, bin, sys, adm, uucp, nobody and lpd.
# This change disables direct local and remote login to the generic system
# accounts i.e. daemon, bin, sys, adm, uucp, nobody and lpd. It is recommended
# that a password is not set on these accounts to ensure that the only access
# is via su from the root account.
#
# Refer to Section(s) 1.2.7,9 Page(s) 31,33 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_user_root_rlogin

class pulsar::service::shell::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linx|AIX/ {
      init_message { "pulsar::service::shell": }
    }
  }
}

class pulsar::service::shell::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linx|AIX/ {
      if $kernel == "AIX" {
        check_lssec { "pulsar::service::shell::rlogin":
          file   => "user",
          stanza => "root",
          param  => "rlogin",
          value  => "false",
        }
        $user_list = [ 'daemon', 'bin', 'sys', 'adm', 'uucp', 'nobody', 'lpd' ]
        disable_remote_login { $user_list: }
      }
      if $kernel =~ /SunOS|Linux/ {
        if $kernel == 'SunOS' {
          $shell_services = [
            'svc:/network/shell:kshell', 'svc:/network/login:eklogin',
            'svc:/network/login:klogin', 'svc:/network/rpc/rex:default',
            'svc:/network/rexec:default', 'svc:/network/shell:default',
            'svc:/network/login:rlogin', 'svc:/network/telnet:default'
          ]
        }
        if $kernel == 'Linux' {
          $shell_services = [ 'telnet', 'login', 'rlogin', 'rsh', 'shell' ]
        }
      }
      disable_service { $shell_services: }
    }
  }
}

