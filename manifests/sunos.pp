# SunOS (Solaris) related audit

# Check ndd boot script

define check_ndd_init () {
  $file    = "/etc/init.d/ndd-network"
  $temp    = "pulsar_sunos_init_ndd_network"
  $fact    = inline_template("<%= scope.lookupvar(temp) %>")
  $secure  = "Statup script ${file_name} exists"
  $warning = "Statup script ${file_name} does not exist"
  $fixing  = "Creating init script \"${file}\""
  $script  = "#!/bin/sh
#
# USM ndd config script for Solaris network parameters

state      = \"$1\"
os_version = `uname -r |cut -f2 -d '.'`

case \"$state\" in
'start')
  ndd -set /dev/ip ip_forward_src_routed 0
  ndd -set /dev/ip ip_forwarding 0
  if [ \"$os_version\" = \"8\" ] || [ \"$os_version\" = \"9\" ] || [ \"$os_version\" = \"10\" ]; then
    ndd -set /dev/ip ip6_forward_src_routed 0
    ndd -set /dev/tcp tcp_rev_src_routes 0
    ndd -set /dev/ip ip6_forwarding 0
  fi
  ndd -set /dev/ip ip_forward_directed_broadcasts 0
  ndd -set /dev/tcp tcp_conn_req_max_q0 4096
  ndd -set /dev/tcp tcp_conn_req_max_q 1024
  ndd -set /dev/ip ip_respond_to_timestamp 0
  ndd -set /dev/ip ip_respond_to_timestamp_broadcast 0
  ndd -set /dev/ip ip_respond_to_address_mask_broadcast 0
  ndd -set /dev/ip ip_respond_to_echo_multicast 0
  if [ \"$os_version\" = \"8\" ] || [ \"$os_version\" = \"9\" ] || [ \"$os_version\" = \"10\" ]; then
    ndd -set /dev/ip ip6_respond_to_echo_multicast 0
  fi
  ndd -set /dev/ip ip_respond_to_echo_broadcast 0
  ndd -set /dev/arp arp_cleanup_interval 60000
  ndd -set /dev/ip ip_ire_arp_interval 60000
  ndd -set/dev/ip ip_ignore_redirect 1
  if [ \"$os_version\" = \"8\" ] || [ \"$os_version\" = \"9\" ] || [ \"$os_version\" = \"10\" ]; then
    ndd -set /dev/ip ip6_ignore_redirect 1
  fi
  ndd -set /dev/tcp tcp_extra_priv_ports_add 6112
  ndd -set /dev/ip ip_strict_dst_multihoming 1
  if [ \"$os_version\" = \"8\" ] || [ \"$os_version\" = \"9\" ] || [ \"$os_version\" = \"10\" ]; then
    ndd -set /dev/ip ip6_strict_dst_multihoming 1
  fi
  ndd -set /dev/ip ip_send_redirects 0
  if [ \"$os_version\" = \"8\" ] || [ \"$os_version\" = \"9\" ] || [ \"$os_version\" = \"10\" ]; then
    ndd -set /dev/ip ip6_send_redirects 0
  fi
  ;;
'stop')
  exit 0
  ;;
*)
  echo \"Usage: $0 start\"
  exit 1
  ;;
esac
exit 0
"
  if $script in $fact {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: }
    }
    else {
      file { $fixing:
        path    => $file,
        content => $script,
      }
    }
  }
}

# Check SunOS crypt package

define check_crypt_package () {
  if $kernelrelease == "5.10" {
    if $pulsar_operatingsystemupdate >= 4 {
      $package_list = [ 'SUNWcry', 'SUNWcryr' ]
      install_package { $package_list: }
    }
  }
}

# Handle ipadm value (Solaris)

define check_ipadm_value ($driver, $param, $value) {
  $temp    = "pulsar_ipadm_${driver}${param}"
  $lc_temp = inline_template("<%= temp.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_temp) %>")
  $secure  = "ipadm parameter ${param} for ${driver} is correctly set to ${value}"
  $warning = "ipadm parameter ${param} ${driver} is not ${value}"
  $fixing  = "Setting ipadm Parameter ${param} for ${driver} to ${value}"
  $command = "ndd -set ${driver} ${param} ${value}"
  $unless  = "ndd -get ${driver} ${param} |grep '${value}'"
  if $fact == $value {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix  => $command }
    }
    else {
      exec { $fixing:
        command => $command,
        unless  => $unless,
      }
    }
  }
}

# Handle ndd value (Solaris)

define check_ndd_value ($driver, $param, $value) {
  if $driver !~ /dev/ {
    $device = "/dev/${driver}"
    $string = $driver
  }
  else {
    $device = $driver
    $string = regsubst($driver,'/dev/','',G)
  }
  $secure  = "ndd parameter ${param} for ${device} is correctly set to ${value}"
  $string  = regsubst($driver,'/','_',G)
  $temp    = "pulsar_ndd_${string}_${param}"
  $lc_temp = inline_template("<%= temp.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_temp) %>")
  $warning = "ndd parameter ${param} for ${device} is not ${value}"
  $command = "ndd -set ${driver_name} ${parameter_name} ${correct_value}"
  $fixing  = "Setting ndd ${param} to ${value} for ${device}"
  $unless  = "ndd -get ${device} ${param} |grep '${value}'"
  if $fact == $value {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix  => $command }
    }
    else {
      exec { $fixing:
        command => $command,
        unless  => $unless,
      }
    }
  }
}

# Handle logadm

define check_logadm_facility () {
  if $name !~ /\./ {
    $facility = "${name}.*"
  }
  else {
    $facility = $name
  }
  $values = split($facility,".")
  $prefix = $values[0]
  if $facility !~ /syslog/ {
    $log_file = "/var/log/${prefix}.log"
  }
  else {
    $log_file = "/var/log/syslog"
  }
  $temp    = "pulsar_${kernel}_logadm_${prefix}"
  $lc_temp = inline_template("<%= temp.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_temp)")
  $command = "logadm -w ${prefix}log -C 13 -a 'pkill -HUP syslogd' ${log_file}"
  $warning = "Logging for ${facility} is not being managed"
  $fixing  = "Adding log management for ${facility}"
  $secure  = "Logs for facility ${facility} are being managed"
  if $facility in $fact {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix  => $command }
    }
    else {
      exec { $fixing:
        command => $command,
      }
    }
  }
}

# Handle inetadm

define check_inetadm ($service, $param, $value) {
  $string  = regsubst($service,'svc:_','','G')
  $temp    = regsubst($string,'/','_','G')
  $info    = "pulsar_inetadm_${temp}_param_${param}"
  $lc_info = inline_template("<%= info.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_info) %>")
  $warning = "Network parameter \"${param}\" for \"${service}\" is not ${value} (Currently \"${fact}\")"
  $command = "inetadm -m ${service} ${param}=${value}"
  $unless  = "inetadm -l ${service} |grep '${param}' |awk '{print $2}' | cut -f2 -d= |grep '${value}'"
  $fixing  = "Setting network parameter ${param} for ${service} to ${value}"
  $secure  = "Network parameter ${param} for ${service} is set to ${value}"
  if $fact != $value {
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
  else {
    if $pulsar_mode =~ /report/ {
      secure_message { $secure: }
    }
  }
}

# Disable service

define disable_routeadm () {
  $status  = "disabled"
  $message = "Disabling ${name}"
  check_routeadm { $message:
    param  => $name,
    status => $status,
  }
}

# Enable service

define enable_routeadm () {
  $status  = "enabled"
  $message = "Enabling ${name}"
  check_routeadm { $message:
    param  => $name,
    status => $status,
  }
}

# Handle routeadm

define check_routeadm ($param, $status) {
  $temp    = "pulsar_routeadm_${param}"
  $lc_temp = inline_template("<%= temp.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_temp) %>")
  $warning = "Route parameter \"${param}\" is not ${fact} (Currently \"${value}\")"
  if $fact =~ /enabled|on/ {
    $command     = "routeadm -e ${param}"
  }
  else {
    $command     = "routeadm -d ${param}"
  }
  $unless = "routeadm -p ${param} |cut -f6 -d= |grep '${value}'"
  $fixing = "Setting route parameter ${param} to ${value}"
  $secure = "Route parameter ${param} is set to ${value}"
  if $fact != $value {
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
  else {
    if $pulsar_mode =~ /report/ {
      secure_message { $secure: }
    }
  }
}

# Handle svc

define check_svccfg ($service, $prop, $value) {
  $string  = regsubst($service,'svc:_','','G')
  $info    = regsubst($string,'/','_','G')
  $temp    = "pulsar_svc_${info}_prop_${param}"
  $lc_temp = inline_template("<%= temp.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_temp) %>")
  $warning = "Service property \"${param}\" for \"${service}\" is not ${value} (Currently \"${fact}\")"
  $unless  = "svcprop -p #{param} #{service} |grep '#{value}'"
  $fixing  = "Setting service property ${param} for ${service} to ${value}"
  $secure  = "Service property ${param} for ${service} is set to ${value}"
  if $value =~ /true|false/ {
    $command = "svccfg -s ${service} setptop ${param} = boolean: ${value}"
  }
  else {
    $command = "svccfg -s ${service} setptop ${param} = astring: ${value}"
  }
  if $fact != $value {
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
  else {
    if $pulsar_mode =~ /report/ {
      secure_message { $secure: }
    }
  }
}

# Handle poweradm

define check_poweradm ($value) {
  $temp    = "pulsar_${kernel}_power_${name}"
  $lc_temp = inline_template("<%= temp.downcase %>")
  $fact    = inline_template("<%= scope.lookupvar(lc_temp) %>")
  $secure  = "Power parameter \"${param}\" correctly set to \"${value}\""
  $warning = "Power parameter \"${param}\" is not correctly set to \"${value}\" (Currently \"${fact}\")"
  $fixing  = "Setting power parameter \"${param}\" to \"${value}\""
  $command = "poweradm set ${param}=${value} ; poweradm update"
  $unless  = "poweradm list | grep ${param} |awk '{print $2}' |cut -f2 -d="
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

# Handle SunOS extended attributes

define process_extended_attributes () {
  $warning = "File \"${name}\" has extended attributes"
  warning_message { $warning: }
}

define check_extended_attributes () {
  if $pulsar_extendedattributes =~ /[A-z]|[0-9]/ {
    $extended_attributes = split($pulsar_extendedattributes,",")
    process_extended_attributes { $extended_attributes: }
  }
}

define check_share () {
  $file    = "/etc/dfs/dfstab"
  $share   = split($name,"\s+")
  $mount   = $share_info[-1]
  $warning = "Mount \"${mount}\" is not using an absolute path"
  $secure  = "Mount \"${mount}\" is secure"
  if $name =~ /^share/ {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: }
    }
    else {
      handle_exec { "Share: ${name}":
        exec  => "cat ${file} |sed \"s,^share,/usr/bin/share,g\" > /tmp/zzz ; cat /tmp/zzz > ${file} ; rm /tmp/zzz",
        check => "cat ${file} |grep \"^share\" |head -1",
        value => "/usr/bin/share"
      }
    }
  }
  else {
    secure_message { $secure: }
  }
}

# Handle SunOS dfstab

define check_dfstab () {
  if $pulsar_exports =~ /share/ {
    $exports_list = split($pulsar_exports,",")
    check_share { $exports_list: }
  }
  else {
    $secure = "No NFS exports"
    secure_message { $secure: }
  }
}

# Check SunOS eeprom security

define check_sunos_eeprom_security () {
  if $pulsar_eeprom_security =~ /none/ {
    $warning = "No EEPROM password set"
    $fixing  = "eeprom security-mode=command"
    warning_message { $warning: fix => $command }
  }
  else {
    $secure = "EEPROM password set"
    secure_message { $secure: }
  }
}

# SunOS (Solaris) related audit

class pulsar::sunos::init {
  if $kernel == "SunOS" {
    init_message { "pulsar::sunos": }
  }
}

class pulsar::sunos {
  if $kernel == "SunOS" {
    include pulsar,                                     pulsar::init
    include pulsar::mode,                               pulsar::sunos::init
    include pulsar::accounting::kernel::init,           pulsar::accounting::kernel::main
    include pulsar::accounting::network::init,          pulsar::accounting::network::main
    include pulsar::accounting::process::init,          pulsar::accounting::process::main
    include pulsar::accounting::sar::init,              pulsar::accounting::sar::main
    include pulsar::accounting::sunos::init,            pulsar::accounting::sunos::main
    include pulsar::accounting::system::init,           pulsar::accounting::system::main
    include pulsar::crypt::package::init,               pulsar::crypt::package::main
    include pulsar::crypt::policy::init,                pulsar::crypt::policy::main
    include pulsar::file::attributes::init,             pulsar::file::attributes::main
    include pulsar::file::metadata::init,               pulsar::file::metadata::main
    include pulsar::file::rhosts::init,                 pulsar::file::rhosts::main
    include pulsar::file::stickybit::init,              pulsar::file::stickybit::main
    include pulsar::file::suid::init,                   pulsar::file::suid::main
    include pulsar::file::unowned::init,                pulsar::file::unowned::main
    include pulsar::file::writable::init,               pulsar::file::writable::main
    include pulsar::firewall::ipfilter::init,           pulsar::firewall::ipfilter::main
    include pulsar::firewall::ipsec::init,              pulsar::firewall::ipsec::main
    include pulsar::firewall::tcpwrappers::init,        pulsar::firewall::tcpwrappers::main
    include pulsar::fs::autofs::init,                   pulsar::fs::autofs::main
    include pulsar::fs::dfstab::init,                   pulsar::fs::dfstab::main
    include pulsar::fs::home::owner::init,              pulsar::fs::home::owner::main
    include pulsar::fs::home::perms::init,              pulsar::fs::home::perms::main
    include pulsar::fs::home::root::init,               pulsar::fs::home::root::main
    include pulsar::fs::mount::setuid::init,            pulsar::fs::mount::setuid::main # Needs fixing
    include pulsar::fs::volfs::init,                    pulsar::fs::volfs::main
    include pulsar::group::root::init,                  pulsar::group::root::main
    include pulsar::kernel::network::init,              pulsar::kernel::network::main
    include pulsar::kernel::route::init,                pulsar::kernel::route::main
    include pulsar::login::console::init,               pulsar::login::console::main
    include pulsar::login::delay::init,                 pulsar::login::delay::main
    include pulsar::login::failed::init,                pulsar::login::failed::main
    include pulsar::login::record::init,                pulsar::login::record::main
    include pulsar::login::retry::init,                 pulsar::login::retry::main
    include pulsar::login::serial::init,                pulsar::login::serial::main # Needs fixing
    include pulsar::os::core::dump::init,               pulsar::os::core::dump::main
    include pulsar::os::debug::init,                    pulsar::os::debug::main
    include pulsar::os::mesgn::init,                    pulsar::os::mesgn::main
    include pulsar::os::shells::init,                   pulsar::os::shells::main
    include pulsar::password::expiry::init,             pulsar::password::expiry::main
    include pulsar::password::perms::init,              pulsar::password::perms::main
    include pulsar::password::required::init,           pulsar::password::required::main
    include pulsar::password::strength::init,           pulsar::password::strength::main
    include pulsar::priv::class::init,                  pulsar::priv::class::main
    include pulsar::priv::events::init,                 pulsar::priv::events::main
    include pulsar::priv::pam::gdm::init,               pulsar::priv::pam::gdm::main # Needs fixing
    include pulsar::priv::pam::rhosts::init,            pulsar::priv::pam::rhosts::main # Needs fixing
    include pulsar::priv::wheel::group::init,           pulsar::priv::wheel::group::main
    include pulsar::priv::wheel::su::init,              pulsar::priv::wheel::su::main
    include pulsar::priv::wheel::sudo::init,            pulsar::priv::wheel::sudo::main
    include pulsar::priv::wheel::users::init,           pulsar::priv::wheel::users::main
    include pulsar::security::banner::init,             pulsar::security::banner::main
    include pulsar::security::daemon::umask::init,      pulsar::security::daemon::umask::main
    include pulsar::security::eeprom::init,             pulsar::security::eeprom::main
    include pulsar::security::grub::init,               pulsar::security::grub::main
    include pulsar::security::issue::init,              pulsar::security::issue::main
    include pulsar::security::rsa::init,                pulsar::security::rsa::main # Needs fixing
    include pulsar::security::stack::init,              pulsar::security::stack::main
    include pulsar::security::tcp::strength::init,      pulsar::security::tcp::strength::main
    include pulsar::security::umask::init,              pulsar::security::umask::main
    include pulsar::service::apache::init,              pulsar::service::apache::main
    include pulsar::service::apocd::init,               pulsar::service::apocd::main
    include pulsar::service::bootparams::init,          pulsar::service::bootparams::main
    include pulsar::service::bpcd::init,                pulsar::service::bpcd::main
    include pulsar::service::bpjava::init,              pulsar::service::bpjava::main
    include pulsar::service::cde::banner::init,         pulsar::service::cde::banner::main # Needs fixing
    include pulsar::service::cde::cal::init,            pulsar::service::cde::cal::main
    include pulsar::service::cde::lock::init,           pulsar::service::cde::lock::main # Needs fixing
    include pulsar::service::cde::print::init,          pulsar::service::cde::print::main
    include pulsar::service::cde::spc::init,            pulsar::service::cde::spc::main
    include pulsar::service::cde::ttdb::init,           pulsar::service::cde::ttdb::main
    include pulsar::service::console::init,             pulsar::service::console::main
    include pulsar::service::cron::allow::init,         pulsar::service::cron::allow::main
    include pulsar::service::cron::logging::init,       pulsar::service::cron::logging::main
    include pulsar::service::dhcp::server::init,        pulsar::service::dhcp::server::main
    include pulsar::service::dns::client::init,         pulsar::service::dns::client::main
    include pulsar::service::dns::server::init,         pulsar::service::dns::server::main
    include pulsar::service::echo::init,                pulsar::service::echo::main
    include pulsar::service::font::init,                pulsar::service::font::main
    include pulsar::service::ftp::banner::init,         pulsar::service::ftp::banner::main
    include pulsar::service::ftp::config::init,         pulsar::service::ftp::config::main # Needs fixing
    include pulsar::service::ftp::logging::init,        pulsar::service::ftp::logging::main
    include pulsar::service::ftp::server::init,         pulsar::service::ftp::server::main
    include pulsar::service::ftp::umask::init,          pulsar::service::ftp::umask::main
    include pulsar::service::ftp::users::init,          pulsar::service::ftp::users::main
    include pulsar::service::gdm::banner::init,         pulsar::service::gdm::banner::main
    include pulsar::service::gdm::lock::init,           pulsar::service::gdm::lock::main
    include pulsar::service::gss::init,                 pulsar::service::gss::main
    include pulsar::service::hotplug::init,             pulsar::service::hotplug::main
    include pulsar::service::inetd::logging::init,      pulsar::service::inetd::logging::main
    include pulsar::service::inetd::server::init,       pulsar::service::inetd::server::main
    include pulsar::service::ipmi::init,                pulsar::service::ipmi::main
    include pulsar::service::iscsi::client::init,       pulsar::service::iscsi::client::main
    include pulsar::service::iscsi::server::init,       pulsar::service::iscsi::server::main
    include pulsar::service::kdm::config::init,         pulsar::service::kdm::config::main
    include pulsar::service::keyserv::config::init,     pulsar::service::keyserv::config::main
    include pulsar::service::keyserv::server::init,     pulsar::service::keyserv::server::main
    include pulsar::service::krb5::server::init,        pulsar::service::krb5::server::main
    include pulsar::service::krb5::tgt::init,           pulsar::service::krb5::tgt::main
    include pulsar::service::labeld::init,              pulsar::service::labeld::main
    include pulsar::service::ldap::cache::init,         pulsar::service::ldap::cache::main
    include pulsar::service::ldap::client::init,        pulsar::service::ldap::client::main
    include pulsar::service::ldap::server::init,        pulsar::service::ldap::server::main
    include pulsar::service::manual::init,              pulsar::service::manual::main
    include pulsar::service::nfs::init,                 pulsar::service::nfs::main
    include pulsar::service::nis::client::init,         pulsar::service::nis::client::main
    include pulsar::service::nis::entries::init,        pulsar::service::nis::entries::main
    include pulsar::service::nis::server::init,         pulsar::service::nis::server::main
    include pulsar::service::nisplus::init,             pulsar::service::nisplus::main
    include pulsar::service::ntp::init,                 pulsar::service::ntp::main
    include pulsar::service::ocfserv::init,             pulsar::service::ocfserv::main
    include pulsar::service::opengl::init,              pulsar::service::opengl::main
    include pulsar::service::power::init,               pulsar::service::power::main
    include pulsar::service::ppd::init,                 pulsar::service::ppd::main
    include pulsar::service::print::server::init,       pulsar::service::print::server::main
    include pulsar::service::rarp::init,                pulsar::service::rarp::main
    include pulsar::service::remote::init,              pulsar::service::remote::main
    include pulsar::service::route::init,               pulsar::service::route::main
    include pulsar::service::rpcbind::init,             pulsar::service::rpcbind::main
    include pulsar::service::samba::init,               pulsar::service::samba::main
    include pulsar::service::sendmail::aliases::init,   pulsar::service::sendmail::aliases::main
    include pulsar::service::sendmail::config::init,    pulsar::service::sendmail::config::main
    include pulsar::service::sendmail::greeting::init,  pulsar::service::sendmail::greeting::main
    include pulsar::service::shell::init,               pulsar::service::shell::main
    include pulsar::service::slp::init,                 pulsar::service::slp::main
    include pulsar::service::smb::config::init,         pulsar::service::smb::config::main
    include pulsar::service::smb::passwd::init,         pulsar::service::smb::passwd::main
    include pulsar::service::snmp::init,                pulsar::service::snmp::main
    include pulsar::service::ssh::config::init,         pulsar::service::ssh::config::main
    include pulsar::service::ssh::keys::init,           pulsar::service::ssh::keys::main
    include pulsar::service::st::init,                  pulsar::service::st::main
    include pulsar::service::suspend::init,             pulsar::service::suspend::main
    include pulsar::service::svm::cli::init,            pulsar::service::svm::cli::main
    include pulsar::service::svm::gui::init,            pulsar::service::svm::gui::main
    include pulsar::service::syslog::auth::init,        pulsar::service::syslog::auth::main
    include pulsar::service::syslog::config::init,      pulsar::service::syslog::config::main
    include pulsar::service::syslog::perms::init,       pulsar::service::syslog::perms::main
    include pulsar::service::syslog::server::init,      pulsar::service::syslog::server::pre
    include pulsar::service::syslog::server::main
    include pulsar::service::telnet::banner::init,      pulsar::service::telnet::banner::main
    include pulsar::service::tftp::server::init,        pulsar::service::tftp::server::main
    include pulsar::service::ticotsord::init,           pulsar::service::ticotsord::main
    include pulsar::service::tname::init,               pulsar::service::tname::main
    include pulsar::service::tnd::init,                 pulsar::service::tnd::main
    include pulsar::service::uucp::init,                pulsar::service::uucp::main
    include pulsar::service::vnc::init,                 pulsar::service::vnc::main
    include pulsar::service::vnetd::init,               pulsar::service::vnetd::main
    include pulsar::service::vopied::init,              pulsar::service::vopied::main
    include pulsar::service::wbem::init,                pulsar::service::wbem::main
    include pulsar::service::webconsole::init,          pulsar::service::webconsole::main
    include pulsar::service::webmin::init,              pulsar::service::webmin::main
    include pulsar::service::winbind::init,             pulsar::service::winbind::main
    include pulsar::service::wins::init,                pulsar::service::wins::main
    include pulsar::service::x11::login::init,          pulsar::service::x11::login::main
    include pulsar::service::zones::init,               pulsar::service::zones::main
    include pulsar::user::dotfiles::init,               pulsar::user::dotfiles::main
    include pulsar::user::duplicate::init,              pulsar::user::duplicate::main
    include pulsar::user::inactive::init,               pulsar::user::inactive::main
    include pulsar::user::netrc::init,                  pulsar::user::netrc::main
    include pulsar::user::old::init,                    pulsar::user::old::main
    include pulsar::user::path::init,                   pulsar::user::path::main
    include pulsar::user::reserved::init,               pulsar::user::reserved::main
    include pulsar::user::rhosts::init,                 pulsar::user::rhosts::main
    include pulsar::user::super::init,                  pulsar::user::super::main
    include pulsar::user::system::init,                 pulsar::user::system::main
    include pulsar::exit
    if $pulsar_mode =~ /report/ {
      Class['pulsar']->                                     Class['pulsar::init']->
      Class['pulsar::mode']->                               Class['pulsar::sunos::init']->
      Class['pulsar::accounting::kernel::init']->           Class['pulsar::accounting::kernel::main']->
      Class['pulsar::accounting::network::init']->          Class['pulsar::accounting::network::main']->
      Class['pulsar::accounting::process::init']->          Class['pulsar::accounting::process::main']->
      Class['pulsar::accounting::sar::init']->              Class['pulsar::accounting::sar::main']->
      Class['pulsar::accounting::sunos::init']->            Class['pulsar::accounting::sunos::main']->
      Class['pulsar::accounting::system::init']->           Class['pulsar::accounting::system::main']->
      Class['pulsar::crypt::package::init']->               Class['pulsar::crypt::package::main']->
      Class['pulsar::crypt::policy::init']->                Class['pulsar::crypt::policy::main']->
      Class['pulsar::file::attributes::init']->             Class['pulsar::file::attributes::main']->
      Class['pulsar::file::metadata::init']->               Class['pulsar::file::metadata::main']->
      Class['pulsar::file::rhosts::init']->                 Class['pulsar::file::rhosts::main']->
      Class['pulsar::file::stickybit::init']->              Class['pulsar::file::stickybit::main']->
      Class['pulsar::file::suid::init']->                   Class['pulsar::file::suid::main']->
      Class['pulsar::file::unowned::init']->                Class['pulsar::file::unowned::main']->
      Class['pulsar::file::writable::init']->               Class['pulsar::file::writable::main']->
      Class['pulsar::firewall::ipfilter::init']->           Class['pulsar::firewall::ipfilter::main']->
      Class['pulsar::firewall::ipsec::init']->              Class['pulsar::firewall::ipsec::main']->
      Class['pulsar::firewall::tcpwrappers::init']->        Class['pulsar::firewall::tcpwrappers::main']->
      Class['pulsar::fs::autofs::init']->                   Class['pulsar::fs::autofs::main']->
      Class['pulsar::fs::dfstab::init']->                   Class['pulsar::fs::dfstab::main']->
      Class['pulsar::fs::home::owner::init']->              Class['pulsar::fs::home::owner::main']->
      Class['pulsar::fs::home::perms::init']->              Class['pulsar::fs::home::perms::main']->
      Class['pulsar::fs::home::root::init']->               Class['pulsar::fs::home::root::main']->
      Class['pulsar::fs::mount::setuid::init']->            Class['pulsar::fs::mount::setuid::main']->
      Class['pulsar::fs::volfs::init']->                    Class['pulsar::fs::volfs::main']->
      Class['pulsar::group::root::init']->                  Class['pulsar::group::root::main']->
      Class['pulsar::kernel::network::init']->              Class['pulsar::kernel::network::main']->
      Class['pulsar::kernel::route::init']->                Class['pulsar::kernel::route::main']->
      Class['pulsar::login::console::init']->               Class['pulsar::login::console::main']->
      Class['pulsar::login::delay::init']->                 Class['pulsar::login::delay::main']->
      Class['pulsar::login::failed::init']->                Class['pulsar::login::failed::main']->
      Class['pulsar::login::record::init']->                Class['pulsar::login::record::main']->
      Class['pulsar::login::retry::init']->                 Class['pulsar::login::retry::main']->
      Class['pulsar::login::serial::init']->                Class['pulsar::login::serial::main']->
      Class['pulsar::os::core::dump::init']->               Class['pulsar::os::core::dump::main']->
      Class['pulsar::os::debug::init']->                    Class['pulsar::os::debug::main']->
      Class['pulsar::os::mesgn::init']->                    Class['pulsar::os::mesgn::main']->
      Class['pulsar::os::shells::init']->                   Class['pulsar::os::shells::main']->
      Class['pulsar::password::expiry::init']->             Class['pulsar::password::expiry::main']->
      Class['pulsar::password::perms::init']->              Class['pulsar::password::perms::main']->
      Class['pulsar::password::required::init']->           Class['pulsar::password::required::main']->
      Class['pulsar::password::strength::init']->           Class['pulsar::password::strength::main']->
      Class['pulsar::priv::class::init']->                  Class['pulsar::priv::class::main']->
      Class['pulsar::priv::events::init']->                 Class['pulsar::priv::events::main']->
      Class['pulsar::priv::pam::gdm::init']->               Class['pulsar::priv::pam::gdm::main']->
      Class['pulsar::priv::pam::rhosts::init']->            Class['pulsar::priv::pam::rhosts::main']->
      Class['pulsar::priv::wheel::group::init']->           Class['pulsar::priv::wheel::group::main']->
      Class['pulsar::priv::wheel::su::init']->              Class['pulsar::priv::wheel::su::main']->
      Class['pulsar::priv::wheel::sudo::init']->            Class['pulsar::priv::wheel::sudo::main']->
      Class['pulsar::priv::wheel::users::init']->           Class['pulsar::priv::wheel::users::main']->
      Class['pulsar::security::banner::init']->             Class['pulsar::security::banner::main']->
      Class['pulsar::security::daemon::umask::init']->      Class['pulsar::security::daemon::umask::main']->
      Class['pulsar::security::eeprom::init']->             Class['pulsar::security::eeprom::main']->
      Class['pulsar::security::grub::init']->               Class['pulsar::security::grub::main']->
      Class['pulsar::security::issue::init']->              Class['pulsar::security::issue::main']->
      Class['pulsar::security::rsa::init']->                Class['pulsar::security::rsa::main']->
      Class['pulsar::security::stack::init']->              Class['pulsar::security::stack::main']->
      Class['pulsar::security::tcp::strength::init']->      Class['pulsar::security::tcp::strength::main']->
      Class['pulsar::security::umask::init']->              Class['pulsar::security::umask::main']->
      Class['pulsar::service::apache::init']->              Class['pulsar::service::apache::main']->
      Class['pulsar::service::apocd::init']->               Class['pulsar::service::apocd::main']->
      Class['pulsar::service::bootparams::init']->          Class['pulsar::service::bootparams::main']->
      Class['pulsar::service::bpcd::init']->                Class['pulsar::service::bpcd::main']->
      Class['pulsar::service::bpjava::init']->              Class['pulsar::service::bpjava::main']->
      Class['pulsar::service::cde::banner::init']->         Class['pulsar::service::cde::banner::main']->
      Class['pulsar::service::cde::cal::init']->            Class['pulsar::service::cde::cal::main']->
      Class['pulsar::service::cde::lock::init']->           Class['pulsar::service::cde::lock::main']->
      Class['pulsar::service::cde::print::init']->          Class['pulsar::service::cde::print::main']->
      Class['pulsar::service::cde::spc::init']->            Class['pulsar::service::cde::spc::main']->
      Class['pulsar::service::cde::ttdb::init']->           Class['pulsar::service::cde::ttdb::main']->
      Class['pulsar::service::console::init']->             Class['pulsar::service::console::main']->
      Class['pulsar::service::cron::allow::init']->         Class['pulsar::service::cron::allow::main']->
      Class['pulsar::service::cron::logging::init']->       Class['pulsar::service::cron::logging::main']->
      Class['pulsar::service::dhcp::server::init']->        Class['pulsar::service::dhcp::server::main']->
      Class['pulsar::service::dns::client::init']->         Class['pulsar::service::dns::client::main']->
      Class['pulsar::service::dns::server::init']->         Class['pulsar::service::dns::server::main']->
      Class['pulsar::service::echo::init']->                Class['pulsar::service::echo::main']->
      Class['pulsar::service::font::init']->                Class['pulsar::service::font::main']->
      Class['pulsar::service::ftp::banner::init']->         Class['pulsar::service::ftp::banner::main']->
      Class['pulsar::service::ftp::config::init']->         Class['pulsar::service::ftp::config::main']->
      Class['pulsar::service::ftp::logging::init']->        Class['pulsar::service::ftp::logging::main']->
      Class['pulsar::service::ftp::server::init']->         Class['pulsar::service::ftp::server::main']->
      Class['pulsar::service::ftp::umask::init']->          Class['pulsar::service::ftp::umask::main']->
      Class['pulsar::service::ftp::users::init']->          Class['pulsar::service::ftp::users::main']->
      Class['pulsar::service::gdm::banner::init']->         Class['pulsar::service::gdm::banner::main']->
      Class['pulsar::service::gdm::lock::init']->           Class['pulsar::service::gdm::lock::main']->
      Class['pulsar::service::gss::init']->                 Class['pulsar::service::gss::main']->
      Class['pulsar::service::hotplug::init']->             Class['pulsar::service::hotplug::main']->
      Class['pulsar::service::inetd::logging::init']->      Class['pulsar::service::inetd::logging::main']->
      Class['pulsar::service::inetd::server::init']->       Class['pulsar::service::inetd::server::main']->
      Class['pulsar::service::ipmi::init']->                Class['pulsar::service::ipmi::main']->
      Class['pulsar::service::iscsi::client::init']->       Class['pulsar::service::iscsi::client::main']->
      Class['pulsar::service::iscsi::server::init']->       Class['pulsar::service::iscsi::server::main']->
      Class['pulsar::service::kdm::config::init']->         Class['pulsar::service::kdm::config::main']->
      Class['pulsar::service::keyserv::config::init']->     Class['pulsar::service::keyserv::config::main']->
      Class['pulsar::service::keyserv::server::init']->     Class['pulsar::service::keyserv::server::main']->
      Class['pulsar::service::krb5::server::init']->        Class['pulsar::service::krb5::server::main']->
      Class['pulsar::service::krb5::tgt::init']->           Class['pulsar::service::krb5::tgt::main']->
      Class['pulsar::service::labeld::init']->              Class['pulsar::service::labeld::main']->
      Class['pulsar::service::ldap::cache::init']->         Class['pulsar::service::ldap::cache::main']->
      Class['pulsar::service::ldap::client::init']->        Class['pulsar::service::ldap::client::main']->
      Class['pulsar::service::ldap::server::init']->        Class['pulsar::service::ldap::server::main']->
      Class['pulsar::service::manual::init']->              Class['pulsar::service::manual::main']->
      Class['pulsar::service::nfs::init']->                 Class['pulsar::service::nfs::main']->
      Class['pulsar::service::nis::client::init']->         Class['pulsar::service::nis::client::main']->
      Class['pulsar::service::nis::entries::init']->        Class['pulsar::service::nis::entries::main']->
      Class['pulsar::service::nis::server::init']->         Class['pulsar::service::nis::server::main']->
      Class['pulsar::service::nisplus::init']->             Class['pulsar::service::nisplus::main']->
      Class['pulsar::service::ntp::init']->                 Class['pulsar::service::ntp::main']->
      Class['pulsar::service::ocfserv::init']->             Class['pulsar::service::ocfserv::main']->
      Class['pulsar::service::opengl::init']->              Class['pulsar::service::opengl::main']->
      Class['pulsar::service::power::init']->               Class['pulsar::service::power::main']->
      Class['pulsar::service::ppd::init']->                 Class['pulsar::service::ppd::main']->
      Class['pulsar::service::print::server::init']->       Class['pulsar::service::print::server::main']->
      Class['pulsar::service::rarp::init']->                Class['pulsar::service::rarp::main']->
      Class['pulsar::service::remote::init']->              Class['pulsar::service::remote::main']->
      Class['pulsar::service::route::init']->               Class['pulsar::service::route::main']->
      Class['pulsar::service::rpcbind::init']->             Class['pulsar::service::rpcbind::main']->
      Class['pulsar::service::samba::init']->               Class['pulsar::service::samba::main']->
      Class['pulsar::service::sendmail::aliases::init']->   Class['pulsar::service::sendmail::aliases::main']->
      Class['pulsar::service::sendmail::config::init']->    Class['pulsar::service::sendmail::config::main']->
      Class['pulsar::service::sendmail::greeting::init']->  Class['pulsar::service::sendmail::greeting::main']->
      Class['pulsar::service::shell::init']->               Class['pulsar::service::shell::main']->
      Class['pulsar::service::slp::init']->                 Class['pulsar::service::slp::main']->
      Class['pulsar::service::smb::config::init']->         Class['pulsar::service::smb::config::main']->
      Class['pulsar::service::smb::passwd::init']->         Class['pulsar::service::smb::passwd::main']->
      Class['pulsar::service::snmp::init']->                Class['pulsar::service::snmp::main']->
      Class['pulsar::service::ssh::config::init']->         Class['pulsar::service::ssh::config::main']->
      Class['pulsar::service::ssh::keys::init']->           Class['pulsar::service::ssh::keys::main']->
      Class['pulsar::service::st::init']->                  Class['pulsar::service::st::main']->
      Class['pulsar::service::suspend::init']->             Class['pulsar::service::suspend::main']->
      Class['pulsar::service::svm::cli::init']->            Class['pulsar::service::svm::cli::main']->
      Class['pulsar::service::svm::gui::init']->            Class['pulsar::service::svm::gui::main']->
      Class['pulsar::service::syslog::auth::init']->        Class['pulsar::service::syslog::auth::main']->
      Class['pulsar::service::syslog::config::init']->      Class['pulsar::service::syslog::config::main']->
      Class['pulsar::service::syslog::perms::init']->       Class['pulsar::service::syslog::perms::main']->
      Class['pulsar::service::syslog::server::init']->      Class['pulsar::service::syslog::server::pre']->
      Class['pulsar::service::syslog::server::main']->
      Class['pulsar::service::telnet::banner::init']->      Class['pulsar::service::telnet::banner::main']->
      Class['pulsar::service::tftp::server::init']->        Class['pulsar::service::tftp::server::main']->
      Class['pulsar::service::ticotsord::init']->           Class['pulsar::service::ticotsord::main']->
      Class['pulsar::service::tname::init']->               Class['pulsar::service::tname::main']->
      Class['pulsar::service::tnd::init']->                 Class['pulsar::service::tnd::main']->
      Class['pulsar::service::uucp::init']->                Class['pulsar::service::uucp::main']->
      Class['pulsar::service::vnc::init']->                 Class['pulsar::service::vnc::main']->
      Class['pulsar::service::vnetd::init']->               Class['pulsar::service::vnetd::main']->
      Class['pulsar::service::vopied::init']->              Class['pulsar::service::vopied::main']->
      Class['pulsar::service::wbem::init']->                Class['pulsar::service::wbem::main']->
      Class['pulsar::service::webconsole::init']->          Class['pulsar::service::webconsole::main']->
      Class['pulsar::service::webmin::init']->              Class['pulsar::service::webmin::main']->
      Class['pulsar::service::winbind::init']->             Class['pulsar::service::winbind::main']->
      Class['pulsar::service::wins::init']->                Class['pulsar::service::wins::main']->
      Class['pulsar::service::x11::login::init']->          Class['pulsar::service::x11::login::main']->
      Class['pulsar::service::zones::init']->               Class['pulsar::service::zones::main']->
      Class['pulsar::user::dotfiles::init']->               Class['pulsar::user::dotfiles::main']->
      Class['pulsar::user::duplicate::init']->              Class['pulsar::user::duplicate::main']->
      Class['pulsar::user::inactive::init']->               Class['pulsar::user::inactive::main']->
      Class['pulsar::user::netrc::init']->                  Class['pulsar::user::netrc::main']->
      Class['pulsar::user::old::init']->                    Class['pulsar::user::old::main']->
      Class['pulsar::user::path::init']->                   Class['pulsar::user::path::main']->
      Class['pulsar::user::reserved::init']->               Class['pulsar::user::reserved::main']->
      Class['pulsar::user::rhosts::init']->                 Class['pulsar::user::rhosts::main']->
      Class['pulsar::user::super::init']->                  Class['pulsar::user::super::main']->
      Class['pulsar::user::system::init']->                 Class['pulsar::user::system::main']->
      Class['pulsar::exit']
    }
  }
}
