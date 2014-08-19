# AIX related functions

# Handle AIX chuser

define check_lsuser_login ($login, $rlogin) {
  $fact    = $pulsar_lsuser_login_rlogin
  $value   = "${name} login=${login} rlogin=${rlogin}"
  $secure  = "Login parameters correctly set to \"${value}\""
  $warning = "Login paramaters not correctly set to \"${value}\" (Currently \"${fact})\""
  $command = "chuser login=${login} rlogin=${rlogin} ${name}"
  $fixing  = "Setting parameters for ${correct_value}"
  $unless  = "lsuser -a login rlogin ${name}"
  if $value in $fact {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        command => $command,
        unless  => $unless,
      }
    }
  }
}

# Handle AIX chsec

define check_lssec ($file, $stanza, $param, $value) {
  if $file =~ /^\// {
    if $file =~ /login/ {
      $string = "login"
    }
    if $file =~ /user/ {
      $string = "user"
    }
  }
  else {
    if $file =~ /login/ {
      $s_file = "/etc/security/login.cfg"
    }
    if $file =~ /user/ {
      $s_file = "/etc/security/user"
    }
    $string = $file
  }
  $temp    = "pulsar_lssec_${string}_${stanza}_${param}"
  $lc_temp = inline_template("<%= temp.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_temp) %>")
  $secure  = "Parameter \"${param}\" for \"${stanza}\" in \"${file}\" is set to \"${value}\""
  $warning = "lssec parameter \"${param}\" for \"${stanza}\" in \"${file}\" not set to \"${value}\" (Currently \"${fact}\")"
  $command = "chsec -f ${file} -s ${stanza} -a ${param}=${value}"
  $unless  = "lssec -f ${file} -s ${stanza} -a ${param} 2>&1 |cut -f2 -d= |sed 's/ $//g' |grep \"^${value}\""
  $fixing  = "Setting lssec parameter ${param} for ${stanza} to ${value}"
  if $actual_value == $correct_value {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        command => $command,
        unless  => $unless,
      }
    }
  }
}

# Handle AIX trustchk

define check_trustchk ($param $value) {
  $temp    = "pulsar_trustchk_${parm}"
  $lc_temp = inline_template("<%= temp.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_temp) %>")
  $secure  = "Parameter \"${param}\" is set to \"${value}\""
  $warning = "trustchk parameter \"${param}\" not set to \"${value}\" (Currently \"${fact}\")"
  $command = "trustchk -p ${param}=${value}"
  $fixing  = "Setting trustchk parameter ${param} to ${value}"
  $unless  = "trustchk -p ${param} 2>&1 |cut -f2 -d= |sed 's/ $//g' |grep \"^${value}\""
  if $fact == $value {
    secure_message { "${secure_message}": }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        command => $command,
        unless  => $unless,
      }
    }
  }
}

# Handle AIX no

define check_no ($param, $value) {
  $temp    = "pulsar_no_${param}"
  $lc_temp = inline_template("<%= temp.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_temp) %>")
  $secure  = "Parameter \"${param}\" is set to \"${value}\""
  $warning = "Parameter \"${param}\" not set to \"${value}\" (Currently \"${fact}\")"
  $command = "no -p -o ${param}=${value}"
  $fixing  = "Setting no parameter ${param} to ${value}"
  $unless  = "no -a 2>&1 |grep '${param}' |cut -f2 -d= |sed 's/ $//g' |grep \"^${value}\""
  if $fact == $value {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        command => $command,
        unless  => $unless,
      }
    }
  }

# Disable service

define disable_rctcp () {
  $status   = "disabled"
  $message = "Disabling ${name}"
  check_rctcp { $message:
    service => $name,
    status  => $status,
  }
}

# Enable service

define enable_aix_rctcp () {
  $status   = "enabled"
  $message = "Enabling ${name}"
  check_rctcp { $message:
    service => $name,
    status  => $status,
  }
}


# Handle rctcp

define check_rctcp ($service, $status) {
  $fact    = $pulsar_rctcp
  $enable  = "chrctcp -a ${service}"
  $disable = "chrctcp -d ${service}"
  $secure  = "Service ${service} is ${status}"
  $warning = "Service ${service} is not ${status}"
  $fixing  = "Setting ${service} to ${status}"
  if $status =~ /enabled|on/ {
    $unless = "cat /etc/chrctcp |grep -v '^#' |grep '${service_name}' |wc -l |sed 's/ //g' |grep '^0$'"
  }
  else {
    $unless = "cat /etc/chrctcp |grep '^#' |grep '${service_name}' |wc -l |sed 's/ //g' |grep '^0$'"
  }
  if $status =~ /enabled|on/ {
    if $service in $fact {
      secure_message { $secure: }
    }
    else {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix => $enable }
      }
      else {
        exec { $fixing:
          command => $enable,
          unless  => $unless,
        }
      }
    }
  }
  else {
    if $service in $fact {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix => $disable }
      }
      else {
        exec { $fixing:
          command => $disable,
          unless  => $unless,
        }
      }
    }
    else{
      secure_message { $service: }
    }
  }
}

# AIX related audit

class pulsar::aix::init {
  if $kernel == "AIX" {
    init_message { "pulsar::aix": }
  }
}

if $kernel == "AIX" {
  include pulsar,                                   pulsar::init,
  include pulsar::mode,                             pulsar::aix::init
  include pulsar::user::system:::init,           pulsar::user::system:::main
  include pulsar::accounting::sar::init,            pulsar::accounting::sar::main
  include pulsar::file::rhosts::init,               pulsar::file::rhosts::main
  include pulsar::file::stickybit::init,            pulsar::file::stickybit::main
  include pulsar::file::suid::init,                 pulsar::file::suid::main
  include pulsar::file::unowned::init,              pulsar::file::unowned::main
  include pulsar::file::writable::init,             pulsar::file::writable::main
  include pulsar::firewall::tcpwrappers::init,      pulsar::firewall::tcpwrappers::main
  include pulsar::fs::home::owner::init,            pulsar::fs::home::owner::main
  include pulsar::fs::home::perms::init,            pulsar::fs::home::perms::main
  include pulsar::fs::home::root::init,             pulsar::fs::home::root::main
  include pulsar::group::root::init,                pulsar::group::root::main
  include pulsar::login::retry::init,               pulsar::login::retry::main
  include pulsar::login::serial::init,              pulsar::login::serial::main
  include pulsar::os::mesgn::init,                  pulsar::os::mesgn::main
  include pulsar::security::banner::init,           pulsar::security::banner::main
  include pulsar::security::ipv6::init,             pulsar::security::ipv6::main
  include pulsar::security::issue::init,            pulsar::security::issue::main
  include pulsar::security::trusted::init,          pulsar::security::trusted::main
  include pulsar::service::dhcp::client::init,      pulsar::service::dhcp::client::main
  include pulsar::service::dhcp::relay::init,       pulsar::service::dhcp::relay::main
  include pulsar::service::dhcp::server::init,      pulsar::service::dhcp::server::main
  include pulsar::service::dns::server::init,       pulsar::service::dns::server::main
  include pulsar::service::i4ls::init,              pulsar::service::i4ls::main
  include pulsar::service::manual::init,            pulsar::service::manual::main
  include pulsar::service::ncs::init,               pulsar::service::ncs::main
  include pulsar::service::power::init,             pulsar::service::power::main
  include pulsar::service::print::server::init,     pulsar::service::print::server::main
  include pulsar::service::route::init,             pulsar::service::route::main
  include pulsar::service::sendmail::config::init,  pulsar::service::sendmail::config::main
  include pulsar::service::shell::init,             pulsar::service::shell::main
  include pulsar::service::snmp::init,              pulsar::service::snmp::main
  include pulsar::service::ssh::config::init,       pulsar::service::ssh::config::main
  include pulsar::service::ssh::keys::init,         pulsar::service::ssh::keys::main
  include pulsar::service::writeserv::init,         pulsar::service::writeserv::main
  include pulsar::user::dotfiles::init,             pulsar::user::dotfiles::main
  include pulsar::user::duplicate::init,            pulsar::user::duplicate::main
  include pulsar::user::netrc::init,                pulsar::user::netrc::main
  include pulsar::user::path::init,                 pulsar::user::path::main
  include pulsar::user::rhosts::init,               pulsar::user::rhosts::main
  include pulsar::user::super::init,                pulsar::user::super::main
  include pulsar::exit
  if $pulsar_mode =~ /report/ {
    Class['pulsar']->                                   Class['pulsar::init']->
    Class['pulsar::mode']->                             Class['pulsar::aix::init']->
    Class['pulsar::user::system:::init']->           Class['pulsar::user::system::main']->
    Class['pulsar::accounting::sar::init']->            Class['pulsar::accounting::sar::main']->
    Class['pulsar::file::rhosts::init']->               Class['pulsar::file::rhosts::main']->
    Class['pulsar::file::stickybit::init']->            Class['pulsar::file::stickybit::main']->
    Class['pulsar::file::suid::init']->                 Class['pulsar::file::suid::main']->
    Class['pulsar::file::unowned::init']->              Class['pulsar::file::unowned::main']->
    Class['pulsar::file::writable::init']->             Class['pulsar::file::writable::main']->
    Class['pulsar::firewall::tcpwrappers::init']->      Class['pulsar::firewall::tcpwrappers::main']->
    Class['pulsar::fs::home::owner::init']->            Class['pulsar::fs::home::owner::main']->
    Class['pulsar::fs::home::perms::init']->            Class['pulsar::fs::home::perms::main']->
    Class['pulsar::fs::home::root::init']->             Class['pulsar::fs::home::root::main']->
    Class['pulsar::group::root::init']->                Class['pulsar::group::root::main']->
    Class['pulsar::login::retry::init']->               Class['pulsar::login::retry::main']->
    Class['pulsar::login::serial::init']->              Class['pulsar::login::serial::main']->
    Class['pulsar::os::mesgn::init']->                  Class['pulsar::os::mesgn::main']->
    Class['pulsar::security::banner::init']->           Class['pulsar::security::banner::main']->
    Class['pulsar::security::ipv6::init']->             Class['pulsar::security::ipv6::main']->
    Class['pulsar::security::issue::init']->            Class['pulsar::security::issue::main']->
    Class['pulsar::security::trusted::init']->          Class['pulsar::security::trusted::main']->
    Class['pulsar::service::dhcp::client::init']->      Class['pulsar::service::dhcp::client::main']->
    Class['pulsar::service::dhcp::relay::init']->       Class['pulsar::service::dhcp::relay::main']->
    Class['pulsar::service::dhcp::server::init']->      Class['pulsar::service::dhcp::server::main']->
    Class['pulsar::service::dns::server::init']->       Class['pulsar::service::dns::server::main']->
    Class['pulsar::service::i4ls::init']->              Class['pulsar::service::i4ls::main']->
    Class['pulsar::service::manual::init']->            Class['pulsar::service::manual::main']->
    Class['pulsar::service::ncs::init']->               Class['pulsar::service::ncs::main']->
    Class['pulsar::service::power::init']->             Class['pulsar::service::power::main']->
    Class['pulsar::service::route::init']->             Class['pulsar::service::route::main']->
    Class['pulsar::service::print::server::init']->     Class['pulsar::service::print::server::main']->
    Class['pulsar::service::sendmail::config::init']->  Class['pulsar::service::sendmail::config::main']->
    Class['pulsar::service::shell::init']->             Class['pulsar::service::shell::main']->
    Class['pulsar::service::snmp::init']->              Class['pulsar::service::snmp::main']->
    Class['pulsar::service::ssh::config::init']->       Class['pulsar::service::ssh::config::main']->
    Class['pulsar::service::ssh::keys::init']->         Class['pulsar::service::ssh::keys::main']->
    Class['pulsar::service::writeserv::init']->         Class['pulsar::service::writeserv::main']->
    Class['pulsar::user::dotfiles::init']->             Class['pulsar::user::dotfiles::main']->
    Class['pulsar::user::duplicate::init']->            Class['pulsar::user::duplicate::main']->
    Class['pulsar::user::netrc::init']->                Class['pulsar::user::netrc::main']->
    Class['pulsar::user::path::init']->                 Class['pulsar::user::path::main']->
    Class['pulsar::user::rhosts::init']->               Class['pulsar::user::rhosts::main']->
    Class['pulsar::user::super::init']->                Class['pulsar::user::super::main']->
    Class['pulsar::exit']
  }
}
