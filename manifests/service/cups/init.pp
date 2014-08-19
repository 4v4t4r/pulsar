# pulsar::service::cups
#
# The Common Unix Print System (CUPS) provides the ability to print to both
# local and network printers. A system running CUPS can also accept print jobs
# from remote systems and print them to local printers. It also provides a web
# based remote administration capability.
#
# Printing Services Turn off cups if not required on Linux.
#
# Refer to Section(s) 3.4 Page(s) 61 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.4 Page(s) 73-4 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.4 Page(s) 64 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.3 Page(s) 53-4 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_cupsd
# Requires fact: pulsar_cups
# Requires fact: pulsar_initfile_cups
# Requires fact: pulsar_perms_configfile_cupsd
# Requires fact: pulsar_perms_configfile_cups
# Requires fact: pulsar_perms_initfile_cups

class pulsar::service::cups::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::cups": }
    }
  }
}

class pulsar::service::cups::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      add_line_to_file { "User lp": path => "cupsd" }
      add_line_to_file { "Group sys": path => "cupsd" }
    }
    $cup_service_list = [ 'cups', 'cups-lpd', 'cupsrenice' ]
    disable_service { $cup_service_list: }
    check_file_perms { "/etc/init.d/cups":
      owner => "root",
      group => "root",
      mode  => "744",
    }
    check_file_perms { "/etc/cups/cupsd.conf":
      owner => "lp",
      group => "sys",
      mode  => "600",
    }
    check_file_perms { "/etc/cups/client.conf":
      owner => "root",
      group => "lp",
      mode  => "644",
    }
  }
}
