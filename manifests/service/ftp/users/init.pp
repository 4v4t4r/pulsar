# pulsar::service::ftp::users
#
# If FTP is permitted to be used on the system, the file /etc/ftpd/ftpusers is
# used to specify a list of users who are not allowed to access the system via
# FTP.
# FTP is an old and insecure protocol that transfers files and credentials in
# clear text and is better replaced by using sftp instead. However, if it is
# permitted for use in your environment, it is important to ensure that the
# default "system" accounts are not permitted to transfer files via FTP,
# especially the root account. Consider also adding the names of other
# privileged or shared accounts that may exist on your system such as user
# oracle and the account which your Web server process runs under.
#.


# Needs finishing

class pulsar::service::ftp::users::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::ftp::users": }
    }
  }
}

class pulsar::service::ftp::users::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        # Needs to be completed
      }
      if $kernel == 'Linux' {
        # Needs to be completed
      }
    }
  }
}
