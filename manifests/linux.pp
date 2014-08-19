# Linux related audit

# Handle fdi

define check_fdi () {
  $fact  = $pulsar_floppycdromfdi
  $file  = $pulsar_configfile_floppycdromfdi
  $perms = $pulsar_perms_configfile_floppycdromfdi
  if $file !~ /file does not exist/ {
    check_file_perms { $file:
      fact  => $perms,
      owner => "root",
      group => "root",
      mode  => "0640",
    }
    $secure  = "User mountable file systems are set to be nodev and nosuid"
    $warning = "User mountable file systems are not set to be nodev and nosuid"
    $fdi_info = "
<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?> <!-- -*- SGML -*- --> >
<deviceinfo version=\"0.2\">
  <!-- Default policies merged onto computer root object -->
  <device>
    <match key=\"info.udi\" string=\"/org/freedesktop/Hal/devices/computer\">
      <merge key=\"storage.policy.default.mount_option.nodev\" type=\"bool\">true</merge>
      <merge key=\"storage.policy.default.mount_option.nosuid\" type=\"bool\">true</merge>
    </match>' >> $temp_file
  </device>' >> $temp_file
</deviceinfo>' >> $temp_file
"
    if $fdi_info in $fact {
      secure_message { $secure: }
    }
    else {
      warning_message { $warning: }
      create_file { $file: content => $fdi_info }
    }
  }
}

# Check sulogin

define check_sulogin () {
  if $lsbdistid =~ /Red|RedHatEnterpriseServer/ {
    if $lsbmajdistrelease > 5 {
      check_file_exists { "/etc/systemd/system/ctrl-alt-del.target":
        fact   => $pulsar_exists_etc_systemd_system_ctrl_alt_del_target,
        exists => "no",
      }
    }
    else {
      check_value { "pulsar::login::su::":
        path => "/etc/inittab",
        fact => $pulsar_inittab,
        line => "~~:S:wait:/sbin/sulogin",
      }
    }
  }
  else {
    check_value { "pulsar::login::su::":
      path => "/etc/inittab",
      fact => $pulsar_inittab,
      line => "~~:S:wait:/sbin/sulogin",
    }
  }
}


# Handle securetty

define check_securetty () {
  $fact = $pulsar_securetty
  $file = "/etc/securetty"
  $temp = "/tmp/zzz"
  if $fact =~ /tty/ {
    $command = "cat ${file} |sed \"s/^tty.*/#&/\"> ${temp} ; cat ${temp} > ${file} ; rm ${temp}"
    $onlyif  = "cat ${file} |grep '^tty'"
    $fixing  = "Removing TTYs from /etc/securetty"
    if $pulsar_mode =~ /report/ {
      $warning = "TTYs in /etc/securetty"
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        commnd => $command,
        onlyif => $onlyif,
      }
    }
  }
  else {
    $secure = "No TTYs in /etc/securetty"
    secure_message { $secure: }
  }
}

# Handle authconfig

define check_authconfig ($param, $match, $value) {
  $fact    = $pulsar_authconfig
  $string  = "${match} ${value}"
  $secure  = "Parameter \"${param}\" is correctly set to \"${value}\""
  $warning = "Parameter \"${parameter_name}\" is not set to \"${value}\""
  $fixing  = "Setting parameter \"${param}\" to \"${value}\""
  $command = "authconfig --${param}=${value}"
  $unless  = "authconfig --test |grep '${string}"
  if $string in $fact {
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


# Linux related audit

class pulsar::linux::init {
  if $kernel == "Linux" {
    init_message { "pulsar::linux": }
  }
}

class pulsar::linux {
  if $kernel == "Linux" {
    include pulsar,                                     pulsar::init
    include pulsar::mode,                               pulsar::linux::init
    include pulsar::accounting::system::init,           pulsar::accounting::system::pre
    include pulsar::accounting::system::main,           pulsar::accounting::system::post
    include pulsar::file::forward::init,                pulsar::file::forward::main
    include pulsar::file::logs::init,                   pulsar::file::logs::main
    include pulsar::file::unowned::init,                pulsar::file::unowned::main
    include pulsar::file::rhosts::init,                 pulsar::file::rhosts::main
    include pulsar::file::stickybit::init,              pulsar::file::stickybit::main
    include pulsar::file::suid::init,                   pulsar::file::suid::main
    include pulsar::file::writable::init,               pulsar::file::writable::main
    include pulsar::firewall::iptables::init,           pulsar::firewall::iptables::main
    include pulsar::firewall::suse::init,               pulsar::firewall::suse::main
    include pulsar::firewall::tcpwrappers::init,        pulsar::firewall::tcpwrappers::main
    include pulsar::fs::autofs::init,                   pulsar::fs::autofs::main
    include pulsar::fs::home::owner::init,              pulsar::fs::home::owner::main
    include pulsar::fs::home::perms::init,              pulsar::fs::home::perms::main
    include pulsar::fs::home::root::init,               pulsar::fs::home::root::main
    include pulsar::fs::mount::fdi::init,               pulsar::fs::mount::fdi::main
    include pulsar::fs::mount::nodev::init,             pulsar::fs::mount::nodev::main
    include pulsar::fs::mount::noexec::init,            pulsar::fs::mount::noexec::main
    include pulsar::fs::mount::setuid::init,            pulsar::fs::mount::setuid::main
    include pulsar::fs::partition::init,                pulsar::fs::partition::main
    include pulsar::group::duplicate::init,             pulsar::group::duplicate::main
    include pulsar::group::exist::init,                 pulsar::group::exist::main
    include pulsar::group::root::init,                  pulsar::group::root::main
    include pulsar::group::shadow::init,                pulsar::group::shadow::main
    include pulsar::kernel::modprobe::init,             pulsar::kernel::modprobe::main
    include pulsar::kernel::sysctl::init,               pulsar::kernel::sysctl::main
    include pulsar::login::console::init,               pulsar::login::console::main
    include pulsar::login::serial::init,                pulsar::login::serial::main
    include pulsar::login::su::init,                    pulsar::login::su::main
    include pulsar::os::core::dump::init,               pulsar::os::core::dump::main
    include pulsar::os::mesgn::init,                    pulsar::os::mesgn::main
    include pulsar::os::shells::init,                   pulsar::os::shells::main
    include pulsar::password::expiry::init,             pulsar::password::expiry::main
    include pulsar::password::fields::init,             pulsar::password::fields::main
    include pulsar::password::hashing::init,            pulsar::password::hashing::main
    include pulsar::password::perms::init,              pulsar::password::perms::main
    include pulsar::priv::pam::ccreds::init,            pulsar::priv::pam::ccreds::main
    include pulsar::priv::pam::deny::init,              pulsar::priv::pam::deny::main
    include pulsar::priv::pam::history::init,           pulsar::priv::pam::history::main
    include pulsar::priv::pam::magic::init,             pulsar::priv::pam::magic::main
    include pulsar::priv::pam::null::init,              pulsar::priv::pam::null::main
    include pulsar::priv::pam::policy::init,            pulsar::priv::pam::policy::main
    include pulsar::priv::pam::reset::init,             pulsar::priv::pam::reset::main
    include pulsar::priv::pam::uid::init,               pulsar::priv::pam::uid::main
    include pulsar::priv::pam::unlock::init,            pulsar::priv::pam::unlock::main
    include pulsar::priv::pam::wheel::init,             pulsar::priv::pam::wheel::main
    include pulsar::priv::sudo::timeout::init,          pulsar::priv::sudo::timeout::main
    include pulsar::priv::wheel::group::init,           pulsar::priv::wheel::group::main
    include pulsar::priv::wheel::su::init,              pulsar::priv::wheel::su::main
    include pulsar::priv::wheel::sudo::init,            pulsar::priv::wheel::sudo::main
    include pulsar::priv::wheel::users::init,           pulsar::priv::wheel::users::main
    include pulsar::security::aide::init,               pulsar::security::aide::main
    include pulsar::security::apparmour::init,          pulsar::security::apparmour::main
    include pulsar::security::banner::init,             pulsar::security::banner::main
    include pulsar::security::memory::init,             pulsar::security::memory::main
    include pulsar::security::daemon::umask::init,      pulsar::security::daemon::umask::main
    include pulsar::security::daemon::unconfined::init, pulsar::security::daemon::unconfined::main
    include pulsar::security::execshield::init,         pulsar::security::execshield::main
    include pulsar::security::grub::init,               pulsar::security::grub::main
    include pulsar::security::ipv6::init,               pulsar::security::ipv6::main
    include pulsar::security::issue::init,              pulsar::security::issue::main
    include pulsar::security::memory::init,             pulsar::security::memory::main
    include pulsar::security::rsa::init,                pulsar::security::rsa::main
    include pulsar::security::selinux::init,            pulsar::security::selinux::main
    include pulsar::security::tcp::cookies::init,       pulsar::security::tcp::cookies::main
    include pulsar::security::umask::init,              pulsar::security::umask::main
    include pulsar::service::apache::init,              pulsar::service::apache::main
    include pulsar::service::avahi::config::init,       pulsar::service::avahi::config::main
    include pulsar::service::avahi::server::init,       pulsar::service::avahi::server::main
    include pulsar::service::biosdevname::init,         pulsar::service::biosdevname::main
    include pulsar::service::bootparams::init,          pulsar::service::bootparams::main
    include pulsar::service::chkconfig::init,           pulsar::service::chkconfig::main
    include pulsar::service::cron::init,                pulsar::service::cron::main
    include pulsar::service::cron::allow::init,         pulsar::service::cron::allow::main
    include pulsar::service::cron::perms::init,         pulsar::service::cron::perms::main
    include pulsar::service::cups::init,                pulsar::service::cups::main
    include pulsar::service::dhcp::server::init,        pulsar::service::dhcp::server::main
    include pulsar::service::dns::client::init,         pulsar::service::dns::client::main
    include pulsar::service::dns::server::init,         pulsar::service::dns::server::main
    include pulsar::service::email::init,               pulsar::service::email::main
    include pulsar::service::font::init,                pulsar::service::font::main
    include pulsar::service::ftp::banner::init,         pulsar::service::ftp::banner::main
    include pulsar::service::ftp::config::init,         pulsar::service::ftp::config::main
    include pulsar::service::ftp::logging::init,        pulsar::service::ftp::logging::main
    include pulsar::service::ftp::umask::init,          pulsar::service::ftp::umask::main
    include pulsar::service::ftp::users::init,          pulsar::service::ftp::users::main
    include pulsar::service::gdm::config::init,         pulsar::service::gdm::config::main
    include pulsar::service::hotplug::init,             pulsar::service::hotplug::main
    include pulsar::service::iscsi::client::init,       pulsar::service::iscsi::client::main
    include pulsar::service::iscsi::server::init,       pulsar::service::iscsi::server::main
    include pulsar::service::krb5::server::init,        pulsar::service::krb5::server::main
    include pulsar::service::ldap::cache::init,         pulsar::service::ldap::cache::main
    include pulsar::service::ldap::server::init,        pulsar::service::ldap::server::main
    include pulsar::service::legacy::init,              pulsar::service::legacy::main
    include pulsar::service::logrotate::init,           pulsar::service::logrotate::main
    include pulsar::service::nfs::init,                 pulsar::service::nfs::main
    include pulsar::service::nis::client::init,         pulsar::service::nis::client::main
    include pulsar::service::nis::entries::init,        pulsar::service::nis::entries::main
    include pulsar::service::nis::server::init,         pulsar::service::nis::server::main
    include pulsar::service::ntp::init,                 pulsar::service::ntp::main
    include pulsar::service::postfix::init,             pulsar::service::postfix::main
    include pulsar::service::postgresql::init,          pulsar::service::postgresql::main
    include pulsar::service::print::server::init,       pulsar::service::print::server::main
    include pulsar::service::rarp::init,                pulsar::service::rarp::main
    include pulsar::service::route::init,               pulsar::service::route::main
    include pulsar::service::rsh::client::init,         pulsar::service::rsh::client::main
    include pulsar::service::rsh::server::init,         pulsar::service::rsh::server::main
    include pulsar::service::samba::init,               pulsar::service::samba::main
    include pulsar::service::sendmail::aliases::init,   pulsar::service::sendmail::aliases::main
    include pulsar::service::sendmail::config::init,    pulsar::service::sendmail::config::main
    include pulsar::service::sendmail::greeting::init,  pulsar::service::sendmail::greeting::main
    include pulsar::service::shell::init,               pulsar::service::shell::main
    include pulsar::service::snmp::init,                pulsar::service::snmp::main
    include pulsar::service::ssh::config::init,         pulsar::service::ssh::config::main
    include pulsar::service::ssh::keys::init,           pulsar::service::ssh::keys::main
    include pulsar::service::syslog::config::init,      pulsar::service::syslog::config::main
    include pulsar::service::syslog::perms::init,       pulsar::service::syslog::perms::main
    include pulsar::service::syslog::server::init,      pulsar::service::syslog::server::pre
    include pulsar::service::syslog::server::main
    include pulsar::service::talk::client::init,        pulsar::service::talk::client::main
    include pulsar::service::talk::server::init,        pulsar::service::talk::server::main
    include pulsar::service::telnet::client::init,      pulsar::service::telnet::client::main
    include pulsar::service::telnet::server::init,      pulsar::service::telnet::server::main
    include pulsar::service::tftp::server::init,        pulsar::service::tftp::server::main
    include pulsar::service::tftp::client::init,        pulsar::service::tftp::client::main
    include pulsar::service::vnc::init,                 pulsar::service::vnc::main
    include pulsar::service::winbind::init,             pulsar::service::winbind::main
    include pulsar::service::wins::init,                pulsar::service::wins::main
    include pulsar::service::x11::login::init,          pulsar::service::x11::login::main
    include pulsar::service::x11::server::init,         pulsar::service::x11::server::main
    include pulsar::service::xen::init,                 pulsar::service::xen::main
    include pulsar::service::xinetd::services::init,    pulsar::service::xinetd::services::main
    include pulsar::service::xinetd::server::init,      pulsar::service::xinetd::server::main
    include pulsar::service::yum::config::init,         pulsar::service::yum::config::main
    include pulsar::user::dotfiles::init,               pulsar::user::dotfiles::main
    include pulsar::user::duplicate::init,              pulsar::user::duplicate::main
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
      Class['pulsar::mode']->                               Class['pulsar::linux::init']->
      Class['pulsar::accounting::system::init']->           Class['pulsar::accounting::system::pre']->
      Class['pulsar::accounting::system::main']->           Class['pulsar::accounting::system::post']->
      Class['pulsar::file::forward::init']->                Class['pulsar::file::forward::main']->
      Class['pulsar::file::logs::init']->                   Class['pulsar::file::logs::main']->
      Class['pulsar::file::unowned::init']->                Class['pulsar::file::unowned::main']->
      Class['pulsar::file::rhosts::init']->                 Class['pulsar::file::rhosts::main']->
      Class['pulsar::file::stickybit::init']->              Class['pulsar::file::stickybit::main']->
      Class['pulsar::file::suid::init']->                   Class['pulsar::file::suid::main']->
      Class['pulsar::file::writable::init']->               Class['pulsar::file::writable::main']->
      Class['pulsar::firewall::iptables::init']->           Class['pulsar::firewall::iptables::main']->
      Class['pulsar::firewall::suse::init']->               Class['pulsar::firewall::suse::main']->
      Class['pulsar::firewall::tcpwrappers::init']->        Class['pulsar::firewall::tcpwrappers::main']->
      Class['pulsar::fs::autofs::init']->                   Class['pulsar::fs::autofs::main']->
      Class['pulsar::fs::home::owner::init']->              Class['pulsar::fs::home::owner::main']->
      Class['pulsar::fs::home::perms::init']->              Class['pulsar::fs::home::perms::main']->
      Class['pulsar::fs::home::root::init']->               Class['pulsar::fs::home::root::main']->
      Class['pulsar::fs::mount::fdi::init']->               Class['pulsar::fs::mount::fdi::main']->
      Class['pulsar::fs::mount::nodev::init']->             Class['pulsar::fs::mount::nodev::main']->
      Class['pulsar::fs::mount::noexec::init']->            Class['pulsar::fs::mount::noexec::main']->
      Class['pulsar::fs::mount::setuid::init']->            Class['pulsar::fs::mount::setuid::main']->
      Class['pulsar::fs::partition::init']->                Class['pulsar::fs::partition::main']->
      Class['pulsar::group::duplicate::init']->             Class['pulsar::group::duplicate::main']->
      Class['pulsar::group::exist::init']->                 Class['pulsar::group::exist::main']->
      Class['pulsar::group::root::init']->                  Class['pulsar::group::root::main']->
      Class['pulsar::group::shadow::init']->                Class['pulsar::group::shadow::main']->
      Class['pulsar::kernel::modprobe::init']->             Class['pulsar::kernel::modprobe::main']->
      Class['pulsar::kernel::sysctl::init']->               Class['pulsar::kernel::sysctl::main']->
      Class['pulsar::login::console::init']->               Class['pulsar::login::console::main']->
      Class['pulsar::login::serial::init']->                Class['pulsar::login::serial::main']->
      Class['pulsar::login::su::init']->                    Class['pulsar::login::su::main']->
      Class['pulsar::os::core::dump::init']->               Class['pulsar::os::core::dump::main']->
      Class['pulsar::os::mesgn::init']->                    Class['pulsar::os::mesgn::main']->
      Class['pulsar::os::shells::init']->                   Class['pulsar::os::shells::main']->
      Class['pulsar::password::expiry::init']->             Class['pulsar::password::expiry::main']->
      Class['pulsar::password::fields::init']->             Class['pulsar::password::fields::main']->
      Class['pulsar::password::hashing::init']->            Class['pulsar::password::hashing::main']->
      Class['pulsar::password::perms::init']->              Class['pulsar::password::perms::main']->
      Class['pulsar::priv::pam::ccreds::init']->            Class['pulsar::priv::pam::ccreds::main']->
      Class['pulsar::priv::pam::deny::init']->              Class['pulsar::priv::pam::deny::main']->
      Class['pulsar::priv::pam::history::init']->           Class['pulsar::priv::pam::history::main']->
      Class['pulsar::priv::pam::magic::init']->             Class['pulsar::priv::pam::magic::main']->
      Class['pulsar::priv::pam::null::init']->              Class['pulsar::priv::pam::null::main']->
      Class['pulsar::priv::pam::policy::init']->            Class['pulsar::priv::pam::policy::main']->
      Class['pulsar::priv::pam::reset::init']->             Class['pulsar::priv::pam::reset::main']->
      Class['pulsar::priv::pam::uid::init']->               Class['pulsar::priv::pam::uid::main']->
      Class['pulsar::priv::pam::unlock::init']->            Class['pulsar::priv::pam::unlock::main']->
      Class['pulsar::priv::pam::wheel::init']->             Class['pulsar::priv::pam::wheel::main']->
      Class['pulsar::priv::sudo::timeout::init']->          Class['pulsar::priv::sudo::timeout::main']->
      Class['pulsar::priv::wheel::group::init']->           Class['pulsar::priv::wheel::group::main']->
      Class['pulsar::priv::wheel::su::init']->              Class['pulsar::priv::wheel::su::main']->
      Class['pulsar::priv::wheel::sudo::init']->            Class['pulsar::priv::wheel::sudo::main']->
      Class['pulsar::priv::wheel::users::init']->           Class['pulsar::priv::wheel::users::main']->
      Class['pulsar::security::aide::init']->               Class['pulsar::security::aide::main']->
      Class['pulsar::security::apparmour::init']->          Class['pulsar::security::apparmour::main']->
      Class['pulsar::security::banner::init']->             Class['pulsar::security::banner::main']->
      Class['pulsar::security::memory::init']->             Class['pulsar::security::memory::main']->
      Class['pulsar::security::daemon::umask::init']->      Class['pulsar::security::daemon::umask::main']->
      Class['pulsar::security::daemon::unconfined::init']-> Class['pulsar::security::daemon::unconfined::main']->
      Class['pulsar::security::execshield::init']->         Class['pulsar::security::execshield::main']->
      Class['pulsar::security::grub::init']->               Class['pulsar::security::grub::main']->
      Class['pulsar::security::ipv6::init']->               Class['pulsar::security::ipv6::main']->
      Class['pulsar::security::issue::init']->              Class['pulsar::security::issue::main']->
      Class['pulsar::security::rsa::init']->                Class['pulsar::security::rsa::main']->
      Class['pulsar::security::selinux::init']->            Class['pulsar::security::selinux::main']->
      Class['pulsar::security::tcp::cookies::init']->       Class['pulsar::security::tcp::cookies::main']->
      Class['pulsar::security::umask::init']->              Class['pulsar::security::umask::main']->
      Class['pulsar::service::apache::init']->              Class['pulsar::service::apache::main']->
      Class['pulsar::service::avahi::config::init']->       Class['pulsar::service::avahi::config::main']->
      Class['pulsar::service::avahi::server::init']->       Class['pulsar::service::avahi::server::main']->
      Class['pulsar::service::biosdevname::init']->         Class['pulsar::service::biosdevname::main']->
      Class['pulsar::service::bootparams::init']->          Class['pulsar::service::bootparams::main']->
      Class['pulsar::service::chkconfig::init']->           Class['pulsar::service::chkconfig::main']->
      Class['pulsar::service::cron::init']->                Class['pulsar::service::cron::main']->
      Class['pulsar::service::cron::allow::init']->         Class['pulsar::service::cron::allow::main']->
      Class['pulsar::service::cron::perms::init']->         Class['pulsar::service::cron::perms::main']->
      Class['pulsar::service::cups::init']->                Class['pulsar::service::cups::main']->
      Class['pulsar::service::dhcp::server::init']->        Class['pulsar::service::dhcp::server::main']->
      Class['pulsar::service::dns::client::init']->         Class['pulsar::service::dns::client::main']->
      Class['pulsar::service::dns::server::init']->         Class['pulsar::service::dns::server::main']->
      Class['pulsar::service::email::init']->               Class['pulsar::service::email::main']->
      Class['pulsar::service::font::init']->                Class['pulsar::service::font::main']->
      Class['pulsar::service::ftp::banner::init']->         Class['pulsar::service::ftp::banner::main']->
      Class['pulsar::service::ftp::config::init']->         Class['pulsar::service::ftp::config::main']
      Class['pulsar::service::ftp::logging::init']->        Class['pulsar::service::ftp::logging::main']->
      Class['pulsar::service::ftp::umask::init']->          Class['pulsar::service::ftp::umask::main']->
      Class['pulsar::service::ftp::users::init']->          Class['pulsar::service::ftp::users::main']->
      Class['pulsar::service::gdm::config::init']->         Class['pulsar::service::gdm::config::main']->
      Class['pulsar::service::hotplug::init']->             Class['pulsar::service::hotplug::main']->
      Class['pulsar::service::iscsi::client::init']->       Class['pulsar::service::iscsi::client::main']->
      Class['pulsar::service::iscsi::server::init']->       Class['pulsar::service::iscsi::server::main']->
      Class['pulsar::service::krb5::server::init']->        Class['pulsar::service::krb5::server::main']->
      Class['pulsar::service::ldap::cache::init']->         Class['pulsar::service::ldap::cache::main']->
      Class['pulsar::service::ldap::server::init']->        Class['pulsar::service::ldap::server::main']->
      Class['pulsar::service::legacy::init']->              Class['pulsar::service::legacy::main']->
      Class['pulsar::service::logrotate::init']->           Class['pulsar::service::logrotate::main']->
      Class['pulsar::service::nfs::init']->                 Class['pulsar::service::nfs::main']->
      Class['pulsar::service::nis::client::init']->         Class['pulsar::service::nis::client::main']->
      Class['pulsar::service::nis::entries::init']->        Class['pulsar::service::nis::entries::main']->
      Class['pulsar::service::nis::server::init']->         Class['pulsar::service::nis::server::main']->
      Class['pulsar::service::ntp::init']->                 Class['pulsar::service::ntp::main']->
      Class['pulsar::service::postfix::init']->             Class['pulsar::service::postfix::main']->
      Class['pulsar::service::postgresql::init']->          Class['pulsar::service::postgresql::main']->
      Class['pulsar::service::print::server::init']->       Class['pulsar::service::print::server::main']->
      Class['pulsar::service::rarp::init']->                Class['pulsar::service::rarp::main']->
      Class['pulsar::service::route::init']->               Class['pulsar::service::route::main']->
      Class['pulsar::service::rsh::client::init']->         Class['pulsar::service::rsh::client::main']->
      Class['pulsar::service::rsh::server::init']->         Class['pulsar::service::rsh::server::main']->
      Class['pulsar::service::samba::init']->               Class['pulsar::service::samba::main']->
      Class['pulsar::service::sendmail::aliases::init']->   Class['pulsar::service::sendmail::aliases::main']->
      Class['pulsar::service::sendmail::config::init']->    Class['pulsar::service::sendmail::config::main']->
      Class['pulsar::service::sendmail::greeting::init']->  Class['pulsar::service::sendmail::greeting::main']->
      Class['pulsar::service::shell::init']->               Class['pulsar::service::shell::main']->
      Class['pulsar::service::snmp::init']->                Class['pulsar::service::snmp::main']->
      Class['pulsar::service::ssh::config::init']->         Class['pulsar::service::ssh::config::main']->
      Class['pulsar::service::ssh::keys::init']->           Class['pulsar::service::ssh::keys::main']->
      Class['pulsar::service::syslog::config::init']->      Class['pulsar::service::syslog::config::main']->
      Class['pulsar::service::syslog::perms::init']->       Class['pulsar::service::syslog::perms::main']->
      Class['pulsar::service::syslog::server::init']->      Class['pulsar::service::syslog::server::pre']->
      Class['pulsar::service::syslog::server::main']->
      Class['pulsar::service::talk::client::init']->        Class['pulsar::service::talk::client::main']->
      Class['pulsar::service::talk::server::init']->        Class['pulsar::service::talk::server::main']->
      Class['pulsar::service::telnet::client::init']->      Class['pulsar::service::telnet::client::main']->
      Class['pulsar::service::telnet::server::init']->      Class['pulsar::service::telnet::server::main']->
      Class['pulsar::service::tftp::server::init']->        Class['pulsar::service::tftp::server::main']->
      Class['pulsar::service::tftp::client::init']->        Class['pulsar::service::tftp::client::main']->
      Class['pulsar::service::vnc::init']->                 Class['pulsar::service::vnc::main']->
      Class['pulsar::service::winbind::init']->             Class['pulsar::service::winbind::main']->
      Class['pulsar::service::wins::init']->                Class['pulsar::service::wins::main']->
      Class['pulsar::service::x11::login::init']->          Class['pulsar::service::x11::login::main']->
      Class['pulsar::service::x11::server::init']->         Class['pulsar::service::x11::server::main']->
      Class['pulsar::service::xen::init']->                 Class['pulsar::service::xen::main']->
      Class['pulsar::service::xinetd::services::init']->    Class['pulsar::service::xinetd::services::main']->
      CLass['pulsar::service::xinetd::server::init']->      Class['pulsar::service::xinetd::server::main']->
      Class['pulsar::service::yum::config::init']->         Class['pulsar::service::yum::config::main']->
      Class['pulsar::user::dotfiles::init']->               Class['pulsar::user::dotfiles::main']->
      Class['pulsar::user::duplicate::init']->              Class['pulsar::user::duplicate::main']->
      Class['pulsar::user::netrc::init']->                  Class['pulsar::user::netrc::main']->
      Class['pulsar::user::old::init']->                    Class['pulsar::user::old::main']->
      Class['pulsar::user::path::init']->                   Class['pulsar::user::path::main']->
      Class['pulsar::user::reserved::init']->               Class['pulsar::user::reserved::main']->
      Class['pulsar::user::rhosts::init']->                 Class['pulsar::user::rhosts::main']->
      Class['pulsar::user::super::init']->                  Class['pulsar::user::super::main']->
      Class['pulsar::user::system::init']->                 Class['pulsar::user::system::main']->
      Class['pulsar::exit'  ]
    }
  }
}
