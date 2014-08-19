# pulsar::login::record
#
# If the file /var/adm/loginlog exists, it will capture failed login attempt
# messages with the login name, tty specification, and time. This file does
# not exist by default and must be manually created.
# Tracking failed login attempts is critical to determine when an attacker
# is attempting a brute force attack on user accounts. Note that this is only
# for login-based such as login, telnet, rlogin, etc. and does not include SSH.
# Review the loginlog file on a regular basis.
#.

# Needs fixing

class pulsar::login::record::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::login::record": }
    }
  }
}

class pulsar::login::record::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease == '5.10' {
        check_perms { '/var/adm/loginlog':
          owner  => 'root',
          group  => 'root',
          mode   => '640',
        }
        check_exec { 'pulsar::login::record::loginlog':
          exec  => 'logadm -w none -C 13 -a "pkill -HUP syslogd" /var/adm/loginlog',
          check => 'logadm -V |grep -v "^#"',
          value => 'none'
        }
      }
    }
  }
}
