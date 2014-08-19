# pulsar::accounting::network
#
# Auditing of Incoming Network Connections
#.

# Requires fact: pulsar_auditevent

# Needs fixing

class pulsar::accounting::network::init {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == 'SunOS' {
      init_message { "pulsar::accounting::network": }
    }
  }
}

class pulsar::accounting::network::main {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease == '5.11' {
        add_line_to_file { "lck:AUE_ACCEPT": path => "auditevent" }
        add_line_to_file { "lck:AUE_CONNECT": path => "auditevent" }
        add_line_to_file { "lck:AUE_SOCKACCEPT": path => "auditevent" }
        add_line_to_file { "lck:AUE_SOCKCONNECT": path => "auditevent" }
        add_line_to_file { "lck:AUE_inetd_connect": path => "auditevent" }
      }
    }
  }
}
