# pulsar::service::email
#
# Remote mail clients (like Eudora, Netscape Mail and Kmail) may retrieve mail
# from remote mail servers using IMAP, the Internet Message Access Protocol,
# or POP, the Post Office Protocol. If this system is a mail server that must
# offer the POP protocol then either qpopper or cyrus may be activated.
#
# Dovecot is an open source IMAP and POP3 server for Linux based systems.
# Unless POP3 and/or IMAP servers are to be provided to this server, it is
# recommended that the service be deleted.
#
# Refer to Section(s) 3.12 Page(s) 67 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.12 Page(s) 79-80 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.11 Page(s) 60 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

# Needs fixing

class pulsar::service::email::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::email": }
    }
  }
}

class pulsar::service::email::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'Linux' {
      $email_daemon_list = [ 'cyrus', 'imapd', 'qpopper', 'dovecot' ]
      disable_service { $email_daemon_list: }
      uninstall_package { $email_daemon_list: }
    }
  }
}
