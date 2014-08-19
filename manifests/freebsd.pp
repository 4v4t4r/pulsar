# FreeBSD related audit

class pulsar::freebsd::init {
  if $kernel == "FreeBSD" {
    init_message { "pulsar::freebsd": }
  }
}

if $kernel == "FreeBSD" {
  include pulsar,                                   pulsar::init,
  include pulsar::mode,                             pulsar::freebsd::init
  include pulsar::user::system::init,            pulsar::user::system::main
  include pulsar::accounting::system::init,         pulsar::accounting::system::main
  include pulsar::file::logs::init,                 pulsar::file::logs::main
  include pulsar::file::rhosts::init,               pulsar::file::rhosts::main
  include pulsar::file::stickybit::init,            pulsar::file::stickybit::main
  include pulsar::file::suid::init,                 pulsar::file::suid::main
  include pulsar::file::unowned::init,              pulsar::file::unowned::main
  include pulsar::file::writable::init,             pulsar::file::writable::main
  include pulsar::firewall::ipfw::init,             pulsar::firewall::ipfw::main
  include pulsar::firewall::tcpwrappers::init,      pulsar::firewall::tcpwrappers::main
  include pulsar::fs::home::owner::init,            pulsar::fs::home::owner::main
  include pulsar::fs::home::perms::init,            pulsar::fs::home::perms::main
  include pulsar::fs::home::root::init,             pulsar::fs::home::root::main
  include pulsar::fs::mount::setuid::init,          pulsar::fs::mount::setuid::main
  include pulsar::group::root::init,                pulsar::group::root::main
  include pulsar::login::su::init,                  pulsar::login::su::main
  include pulsar::os::core::dump::init,             pulsar::os::core::dump::main
  include pulsar::os::mesgn::init,                  pulsar::os::mesgn::main
  include pulsar::password::strength::init,         pulsar::password::strength::main
  include pulsar::priv::pam::deny::init,            pulsar::priv::pam::deny::main
  include pulsar::security::banner::init,           pulsar::security::banner::main
  include pulsar::security::daemon::umask::init,    pulsar::security::daemon::umask::main
  include pulsar::security::issue::init,            pulsar::security::issue::main
  include pulsar::security::umask::init,            pulsar::security::umask::main
  include pulsar::service::cron::allow::init,       pulsar::service::cron::allow::main
  include pulsar::service::dns::server::init,       pulsar::service::dns::server::main
  include pulsar::service::legacy::init,            pulsar::service::legacy::main
  include pulsar::service::newsyslog::init,         pulsar::service::newsyslog::main
  include pulsar::service::nfs::init,               pulsar::service::nfs::main
  include pulsar::service::nis::server::init,       pulsar::service::nis::server::main
  include pulsar::service::sendmail::config::init,  pulsar::service::sendmail::config::main
  include pulsar::service::ssh::config::init,       pulsar::service::ssh::config::main
  include pulsar::service::ssh::keys::init,         pulsar::service::ssh::keys::main
  include pulsar::service::syslog::config::init,    pulsar::service::syslog::config::main
  include pulsar::service::syslog::perms::init,     pulsar::service::syslog::perms::main
  include pulsar::service::syslog::server::init,    pulsar::service::syslog::server::pre
  include pulsar::service::syslog::server::main
  include pulsar::user::dotfiles::init,             pulsar::user::dotfiles::main
  include pulsar::user::duplicate::init,            pulsar::user::duplicate::main
  include pulsar::user::netrc::init,                pulsar::user::netrc::main
  include pulsar::user::path::init,                 pulsar::user::path::main
  include pulsar::user::rhosts::init,               pulsar::user::rhosts::main
  include pulsar::user::super::init,                pulsar::user::super::main
  include pulsar::exit
  if $pulsar_mode =~ /report/ {
    Class['pulsar']->                                   Class['pulsar::init']->
    Class['pulsar::mode']->                             Class['pulsar::freebsd::init']->
    Class['pulsar::user::system::init']->            Class['pulsar::user::system::main']->
    Class['pulsar::accounting::system::init']->         Class['pulsar::accounting::system::main']->
    Class['pulsar::file::logs::init']->                 Class['pulsar::file::logs::main']->
    Class['pulsar::file::rhosts::init']->               Class['pulsar::file::rhosts::main']->
    Class['pulsar::file::stickybit::init']->            Class['pulsar::file::stickybit::main']->
    Class['pulsar::file::suid::init']->                 Class['pulsar::file::suid::main']->
    Class['pulsar::file::unowned::init']->              Class['pulsar::file::unowned::main']->
    Class['pulsar::file::writable::init']->             Class['pulsar::file::writable::main']->
    Class['pulsar::firewall::ipfw::init']->             Class['pulsar::firewall::ipfw::main']->
    Class['pulsar::firewall::tcpwrappers::init']->      Class['pulsar::firewall::tcpwrappers::main']->
    Class['pulsar::fs::home::owner::init']->            Class['pulsar::fs::home::owner::main']->
    Class['pulsar::fs::home::perms::init']->            Class['pulsar::fs::home::perms::main']->
    Class['pulsar::fs::home::root::init']->             Class['pulsar::fs::home::root::main']->
    Class['pulsar::fs::mount::setuid::init']->          Class['pulsar::fs::mount::setuid::main']->
    Class['pulsar::group::root::init']->                Class['pulsar::group::root::main']->
    Class['pulsar::login::su::init']->                  Class['pulsar::login::su::main']->
    Class['pulsar::os::core::dump::init']->             Class['pulsar::os::core::dump::main']->
    Class['pulsar::os::mesgn::init']->                  Class['pulsar::os::mesgn::main']->
    Class['pulsar::password::strength::init']->         Class['pulsar::password::strength::main']->
    Class['pulsar::priv::pam::deny::init']->            Class['pulsar::priv::pam::deny::main']->
    Class['pulsar::security::banner::init']->           Class['pulsar::security::banner::main']->
    Class['pulsar::security::daemon::umask::init']->    Class['pulsar::security::daemon::umask::main']->
    Class['pulsar::security::issue::init']->            Class['pulsar::security::issue::main']->
    Class['pulsar::security::umask::init']->            Class['pulsar::security::umask::main']->
    Class['pulsar::service::cron::allow::init']->       Class['pulsar::service::cron::allow::main']->
    Class['pulsar::service::dns::server::init']->       Class['pulsar::service::dns::server::main']->
    Class['pulsar::service::legacy::init']->            Class['pulsar::service::legacy::main']->
    Class['pulsar::service::newsyslog::init']->         Class['pulsar::service::newsyslog::main']->
    Class['pulsar::service::nfs::init']->               Class['pulsar::service::nfs::main']
    Class['pulsar::service::nis::server::init']->       Class['pulsar::service::nis::server::main']->
    Class['pulsar::service::sendmail::config::init']->  Class['pulsar::service::sendmail::config::main']->
    Class['pulsar::service::syslog::config::init']->    Class['pulsar::service::syslog::config::main']->
    Class['pulsar::service::syslog::server::init']->    Class['pulsar::service::syslog::server::main']->
    Class['pulsar::service::ssh::config::init']->       Class['pulsar::service::ssh::config::main']->
    Class['pulsar::service::ssh::keys::init']->         Class['pulsar::service::ssh::keys::main']->
    Class['pulsar::service::syslog::config::init']->    Class['pulsar::service::syslog::config::main']->
    Class['pulsar::service::syslog::perms::init']->     Class['pulsar::service::syslog::perms::main']->
    Class['pulsar::service::syslog::server::init']->    Class['pulsar::service::syslog::server::pre']->
    Class['pulsar::service::syslog::server::main']->
    Class['pulsar::user::dotfiles::init']->             Class['pulsar::user::dotfiles::main']->
    Class['pulsar::user::duplicate::init']->            Class['pulsar::user::duplicate::main']->
    Class['pulsar::user::netrc::init']->                Class['pulsar::user::netrc::main']->
    Class['pulsar::user::path::init']->                 Class['pulsar::user::path::main']->
    Class['pulsar::user::rhosts::init']->               Class['pulsar::user::rhosts::main']->
    Class['pulsar::user::super::init']->                Class['pulsar::user::super::main']->
    Class['pulsar::exit']
  }
}
