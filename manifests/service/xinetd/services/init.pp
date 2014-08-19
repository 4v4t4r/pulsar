# pulsar::service::xinetd::services
#
# Audit xinetd services on Linux. Make sure services that are not required
# are not running. Leaving unrequired services running can lead to vectors
# of attack.

# Requires fact: pulsar_xinetdservices
# Requires fact: pulsar_installedpackages

# Needs to be completed - Need to write something to handle xinetd

class pulsar::service::xinetd::services::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::xinetd::services": }
    }
  }
}

class pulsar::service::xinetd::services::main {
  if $kernel == 'Linux' {
    $test_package = "xinetd:"
    if $test_package in $pulsar_installedpackages {
      $xinetd_service_list = [ 'amanda', 'amandaidx', 'amidxtape',
        'auth', 'chargen-dgram', 'chargen-stream', 'cvs', 'daytime-dgram',
        'daytime-stream', 'discard-dgram', 'echo-dgram', 'echo-stream',
        'eklogin', 'ekrb5-telnet', 'gssftp', 'klogin', 'krb5-telnet',
        'kshell', 'ktalk', 'ntalk', 'rexec', 'rlogin', 'rsh', 'rsync', 'talk',
        'tcpmux-server', 'telnet', 'tftp', 'time-dgram', 'time-stream', 'uuc'
      ]
      disable_xinetd_service { $xinetd_service_list: }
    }
    else {
      $secure = "xinetd not installed"
      secure_message { $secure: }
    }
  }
}
