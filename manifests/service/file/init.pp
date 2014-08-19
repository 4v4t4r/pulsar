# pulsar::service::file
#
# Apple's File Sharing uses a combination of many technologies: FTP, SMB
# (Windows sharing) and AFP (Mac sharing). Generally speaking, file sharing
# should be turned off and a dedicated, well-managed file server should be
# used to share files. If file sharing must be turned on, the user should be
# aware of the security implications of each option.
#
# Refer to Section(s) 2.4.8 Page(s) 23-24 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::file::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::file_init": }
    }
  }
}

class pulsar::service::file::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      $service_list = [ "com.apple.AppleFileServer", "ftp", "com.apple.nmbd", "com.apple.smbd" ]
      disable_service { $service_list: }
    }
  }
}
