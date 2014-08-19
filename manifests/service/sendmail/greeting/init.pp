# pulsar::service::sendmail::greeting
#
# Make sure sendmail greeting does not expose version or system information.
# This reduces information that can be obtained remotely and thus reduces
# vectors of attack.
#.

# Requires fact: pulsar_sendmailcf_SmtpGreetingMessage

class pulsar::service::sendmail::greeting::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::sendmail::greeting": }
    }
  }
}

class pulsar::service::sendmail::greeting::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      add_line_to_file { "O SmtpGreetingMessage=Mail Server Ready; $b": path => "sendmailcf" }
    }
  }
}
